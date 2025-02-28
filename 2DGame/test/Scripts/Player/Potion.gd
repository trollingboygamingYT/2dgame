extends Area2D

@onready var full_potion = $FullObject  # Ensure this exists in the scene
@export var float_speed: float = 2  # Speed of floating motion
@export var float_amplitude: float = 4  # How far it moves up and down

var base_position: Vector2
var time_passed: float = 0.0

func _ready():
	add_to_group("potions")  # Add this potion to the "potions" group
	base_position = global_position  # Store the initial position

func _process(delta):
	time_passed += delta * float_speed
	global_position.y = base_position.y + sin(time_passed) * float_amplitude

func _on_body_entered(body):
	if body.is_in_group("player") and not body.has_potion:
		body.pickup_potion(self)  # Pass the potion to the player for pickup
		queue_free()  # Remove potion immediately after pickup
