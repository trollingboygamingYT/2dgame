extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 500.0

# Health variables
var health = 100
const DAMAGE_AMOUNT = 10

# Called when the player is ready in the scene
func _ready():
	add_to_group("player")  # Make sure the player is in the "player" group to be detected
	print("Player Health: ", health)  # Show initial health in the console

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Get input for left and right movement
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

# Function to take damage
func take_damage():
	health -= DAMAGE_AMOUNT
	if health < 0:
		health = 0  # Prevent health from going below 0
	print("Player Health: ", health)  # Display updated health in the console
