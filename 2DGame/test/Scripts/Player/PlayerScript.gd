extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 1000.0
const WALL_JUMP_VELOCITY = Vector2(250, -300)  # Horizontal push when wall jumping
const ATTACK_DAMAGE = 10  # Damage dealt to enemies
const ATTACK_RANGE = 100.0  # Range to hit enemies

var health = 100
const MAX_HEALTH = 100
const DAMAGE_AMOUNT = 10
const Void_Amount = 2147483647
const HEAL_AMOUNT = 20

var potions = 0
@export var pickup_cooldown: float = 0.5
var can_pickup: bool = true

var can_wall_jump = true  # To prevent spamming wall jumps
var last_wall_normal = Vector2.ZERO  # Store last wall direction

@onready var health_bar = $CanvasLayer/HealthBar
@onready var potion_label = $CanvasLayer/PotionLabel

func _ready():
	add_to_group("player")
	update_health_bar()
	update_potion_label()
	var cooldown_timer = Timer.new()
	cooldown_timer.wait_time = pickup_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	add_child(cooldown_timer)
	cooldown_timer.name = "PickupCooldownTimer"

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1

	velocity.x = direction * SPEED

	# Detect valid walls for sliding and jumping
	if is_on_wall():
		var wall_normal = get_custom_wall_normal()

		# Ensure it's a vertical wall (not a floor edge)
		if abs(wall_normal.x) > 0.7:  # Must be mostly horizontal
			if wall_normal != last_wall_normal:
				can_wall_jump = true  # Reset jump when touching a new wall
			last_wall_normal = wall_normal

			# If sliding, reduce fall speed
			if velocity.y > 0:
				velocity.y = GRAVITY * 0.4  # Sliding effect

	# Jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall() and can_wall_jump and abs(last_wall_normal.x) > 0.7:  # Ensure it's a proper wall
			# Jump away from the wall
			velocity = Vector2(WALL_JUMP_VELOCITY.x * -last_wall_normal.x, WALL_JUMP_VELOCITY.y)
			can_wall_jump = false  # Prevent infinite wall jumps

	move_and_slide()
	handle_potion_use()

	# Player attack when pressing the attack button
	if Input.is_action_just_pressed("attack"):
		attack()

func get_custom_wall_normal():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if abs(collision.get_normal().x) > 0.7:  # Make sure it's a valid vertical wall
			return collision.get_normal()
	return Vector2.ZERO

func handle_potion_use():
	if Input.is_action_just_pressed("interact"):
		pickup_nearby_potion()
	if Input.is_action_just_pressed("use_potion"):
		use_potion()

func take_damage_enemy():
	health -= DAMAGE_AMOUNT
	health = max(health, 0)
	update_health_bar()
	if health <= 0:
		die()
		
func take_damage_void():
	health -= Void_Amount
	health = max(health, 0)
	update_health_bar()
	if health <= 0:
		die()

func update_health_bar():
	if health_bar:
		health_bar.value = health

func die():
	print("Player has died!")
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/RespawnScreen.tscn")

func pickup_nearby_potion():
	if not can_pickup:
		print("Pickup on cooldown!")
		return
	var closest_potion = null
	var min_distance = 50.0
	for potion in get_tree().get_nodes_in_group("potions"):
		if global_position.distance_to(potion.global_position) < min_distance:
			closest_potion = potion
	if closest_potion:
		pickup_potion(closest_potion)

func pickup_potion(potion: Area2D):
	if not can_pickup:
		return
	potions += 1
	update_potion_label()
	potion.queue_free()

func use_potion():
	if potions > 0 and health < MAX_HEALTH:
		health = min(health + HEAL_AMOUNT, MAX_HEALTH)
		potions -= 1
		update_health_bar()
		update_potion_label()

func update_potion_label():
	if potion_label:
		potion_label.text = str(potions)

func start_pickup_cooldown():
	can_pickup = false
	get_node("PickupCooldownTimer").start()

func _on_cooldown_timeout():
	can_pickup = true

# Attack function to damage nearby enemies
func attack():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy is CharacterBody2D and global_position.distance_to(enemy.global_position) < ATTACK_RANGE:
			print("Attacking enemy:", enemy)
			enemy.call("take_damage", ATTACK_DAMAGE)  # Calls the enemy's take_damage function
