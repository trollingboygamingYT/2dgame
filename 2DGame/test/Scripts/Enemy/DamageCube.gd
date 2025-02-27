extends Area2D  # or StaticBody2D, depending on your setup

# Damage amount (can be adjusted if needed)
const DAMAGE_AMOUNT = 10

# Called when the node is ready in the scene
func _ready():
	# Connect the body_entered signal to detect when the player enters the area
	connect("body_entered", Callable(self, "_on_body_entered"))

# Function called when a body enters the DamageCube area
func _on_body_entered(body):
	# Check if the body that entered is in the "player" group
	if body.is_in_group("player"):
		# Call the take_damage function on the player
		body.take_damage()
