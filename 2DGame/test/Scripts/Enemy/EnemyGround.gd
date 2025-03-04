# PathFinding And Healthbar
extends CharacterBody2D

# Health system
@onready var health_bar: ProgressBar = $HealthBar  # Reference to health bar
var max_health = 100
var health = max_health  # Enemy health

# Existing variables (unchanged)
var speed: int = 100
var gravity: int = 800
var direction: int = 1
var tracking_player: bool = false  # Track player state

@onready var player = $"../player"  # Adjust path to your player node

func _ready():
	# Initialize health bar
	health_bar.max_value = max_health
	health_bar.value = health

func _process(delta: float) -> void:
	velocity.y += gravity * delta  # Apply gravity

	# Check if the enemy sees the player (front and back detection)
	if ($RayCastPlayerLeft.is_colliding() and $RayCastPlayerLeft.get_collider() == player) or \
	   ($RayCastPlayerRight.is_colliding() and $RayCastPlayerRight.get_collider() == player):
		tracking_player = true  # Start tracking the player
	else:
		tracking_player = false  # Stop tracking

	# Movement logic
	if tracking_player:
		# Move towards the player
		if player.global_position.x < global_position.x:
			direction = -1
			$Sprite2D.flip_h = true
		else:
			direction = 1
			$Sprite2D.flip_h = false
	else:
		# Normal patrol logic
		if not $RayCastLeft.is_colliding() and direction == -1:
			direction = 1
			$Sprite2D.flip_h = false
		elif not $RayCastRight.is_colliding() and direction == 1:
			direction = -1
			$Sprite2D.flip_h = true

	velocity.x = speed * direction  # Apply movement
	move_and_slide()  # Move enemy

# Function to take damage from player attacks
func take_damage(amount):
	health -= amount
	health_bar.value = health  # Update health bar
	print("Enemy took", amount, "damage! Remaining health:", health)
	
	if health <= 0:
		die()

func die():
	print("Enemy has died!")
	queue_free()  # Remove enemy from the scene

# Handle left-click damage using the "attack" action
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):  # Check for the "attack" action
		var mouse_position = get_global_mouse_position()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mouse_position
		query.collide_with_areas = true
		query.collide_with_bodies = true
		
		var results = space_state.intersect_point(query)  # Get all objects at the mouse position
		
		for result in results:  # Iterate through the array of results
			var clicked_node = result.collider
			if clicked_node == self:  # Check if the clicked node is this enemy
				take_damage(10)  # Apply 10 damage to the enemy
				print("Enemy hit with left-click!")
				break  # Exit the loop after hitting the enemy
