extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D  # Adjust path if necessary
@export var sprite_left: Texture2D  # Assign the left sprite in the editor
@export var sprite_right: Texture2D  # Assign the right sprite in the editor

const SPEED = 180.0
func _ready() -> void:
	set_physics_process(false)
	call_deferred("wait_for_physics")
	
func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() and\
					target_to_chase.global_position == navigation_agent.target_position:
		return
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
	move_and_slide()
	
	
	if velocity.x > 0:
		sprite.texture = sprite_right  # Use right-facing sprite
	elif velocity.x < 0:
		sprite.texture = sprite_left   # Use left-facing sprite
