extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 500.0

# Health variables
var health = 100
const MAX_HEALTH = 100
const DAMAGE_AMOUNT = 10
const Void_Amount = 2147483647
const HEAL_AMOUNT = 20

# Potion inventory
var potions = 0

# Cooldown variables
@export var pickup_cooldown: float = 2.0  # Cooldown duration in seconds
var can_pickup: bool = true

# UI References
@onready var health_bar = $CanvasLayer/HealthBar
@onready var potion_label = $CanvasLayer/PotionLabel  # Label to display potion count

func _ready():
	add_to_group("player")
	print("Player Health:", health)
	update_health_bar()
	update_potion_label()

	# Add a cooldown timer to the player
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

	# Movement input
	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1

	velocity.x = direction * SPEED

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

	# Potion pickup (E key)
	if Input.is_action_just_pressed("pickup_potion"):
		pickup_nearby_potion()

	# Use potion (H key)
	if Input.is_action_just_pressed("use_potion"):
		use_potion()

func take_damage_enemy():
	health -= DAMAGE_AMOUNT
	health = max(health, 0)
	print("Player Health:", health)
	update_health_bar()
	if health <= 0:
		die()
		
func take_damage_void():
	health -= Void_Amount
	health = max(health, 0)
	print("Player Health:", health)
	update_health_bar()
	if health <= 0:
		die()

func update_health_bar():
	if health_bar:
		health_bar.value = health

func die():
	print("Player has died!")
	queue_free()

# Pickup potion function (only allows pickup if the potion is nearby)
func pickup_nearby_potion():
	if not can_pickup:
		print("Pickup on cooldown!")
		return

	# Find the nearest potion
	var closest_potion = null
	var min_distance = 50.0  # Adjust the distance as needed

	for potion in get_tree().get_nodes_in_group("potions"):
		if global_position.distance_to(potion.global_position) < min_distance:
			closest_potion = potion
			min_distance = global_position.distance_to(potion.global_position)

	# If a nearby potion is found, pick it up
	if closest_potion:
		pickup_potion(closest_potion)  # Pass the potion instance to the pickup function

# Pickup potion function (increases potions count)
func pickup_potion(potion: Area2D):
	if not can_pickup:
		print("Pickup on cooldown!")
		return

	potions += 1
	update_potion_label()
	print("Picked up a potion! Total:", potions)
	potion.queue_free()  # Remove the potion from the scene

# Use potion function
func use_potion():
	if potions > 0 and health < MAX_HEALTH:
		health += HEAL_AMOUNT
		health = min(health, MAX_HEALTH)  # Ensure health does not exceed max
		potions -= 1
		update_health_bar()
		update_potion_label()
		print("Used a potion! Health:", health, "| Potions left:", potions)
	else:
		print("No potions or health is full!")

# Update potion count label
func update_potion_label():
	if potion_label:
		potion_label.text = "" + str(potions)

# Start pickup cooldown
func start_pickup_cooldown():
	can_pickup = false
	get_node("PickupCooldownTimer").start()
	print("Pickup cooldown started!")

# Called when cooldown ends
func _on_cooldown_timeout():
	can_pickup = true
	print("Pickup cooldown ended!")
