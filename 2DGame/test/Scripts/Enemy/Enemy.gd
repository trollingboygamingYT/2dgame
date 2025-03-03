# IS VOOR PATHFINDING EN DE HEALTH VAN DE ENEMY
extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D  # Adjust path if necessary
@export var sprite_left: Texture2D
@export var sprite_right: Texture2D
@onready var health_bar: ProgressBar = $HealthBar  # Reference to health bar


const SPEED = 180.0
var max_health = 100
var health = max_health  # Enemy health

func _ready() -> void:
	add_to_group("enemies")
	health_bar.max_value = max_health
	health_bar.value = health  # Set initial value
	set_physics_process(false)
	call_deferred("wait_for_physics")
	
func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target_to_chase):  # Ensure player still exists
		return
	
	if navigation_agent.is_navigation_finished() and target_to_chase.global_position == navigation_agent.target_position:
		return
	
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
	move_and_slide()
	
	if velocity.x > 0:
		sprite.texture = sprite_right
	elif velocity.x < 0:
		sprite.texture = sprite_left


# Function to take damage from player attacks
func take_damage(amount):
	health -= amount
	health_bar.value = health  # Update health bar
	print("Enemy took", amount, "damage! Remaining health:", health)
	
	if health <= 0:
		die()

func die():
	print("Enemy has died!")
	queue_free()
