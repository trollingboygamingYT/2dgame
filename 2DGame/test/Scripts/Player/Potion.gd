extends Area2D

@onready var full_potion = $FullObject  # Ensure this exists in the scene

func _ready():
	add_to_group("potions")  # Add this potion to the "potions" group

# When the player enters the potion's area, allow them to pick it up
func _on_body_entered(body):
	if body.is_in_group("player") and not body.has_potion:
		body.pickup_potion(self)  # Pass the potion to the player for pickup
		queue_free()  # Remove potion immediately after pickup
