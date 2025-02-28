extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 500.0

# Health variables
var health = 100
const MAX_HEALTH = 100
const DAMAGE_AMOUNT = 10
const HEAL_AMOUNT = 20

# Potion inventory
var potions = 0

# UI References
@onready var health_bar = $CanvasLayer/HealthBar
@onready var potion_label = $CanvasLayer/PotionLabel  # Label to display potion count

func _ready():
	add_to_group("player")
	print("Player Health:", health)
	update_health_bar()
	update_potion_label()

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

func take_damage():
	health -= DAMAGE_AMOUNT
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
