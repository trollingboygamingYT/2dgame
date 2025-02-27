extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 500.0

# Health variables
var health = 100
const DAMAGE_AMOUNT = 10

# HealthBar reference (now referencing the UI layer)
@onready var health_bar = $CanvasLayer/HealthBar  # Adjust the path based on your scene structure

# Called when the player is ready in the scene
func _ready():
	add_to_group("player")  # Make sure the player is in the "player" group to be detected
	print("Player Health: ", health)  # Show initial health in the console
	update_health_bar()  # Initialize the health bar

# Physics process for movement
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
	update_health_bar()  # Update the health bar
	if health <= 0:
		die()  # Call the die function if health reaches 0

# Function to update the health bar
func update_health_bar():
	if health_bar:
		health_bar.value = health  # Update the health bar's value

# Function to handle player death
func die():
	print("Player has died!")  # Print a message to the console
	queue_free()  # Delete the player node from the scene
