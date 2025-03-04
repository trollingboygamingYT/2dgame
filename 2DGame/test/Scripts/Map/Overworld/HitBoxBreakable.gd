extends Area2D

@onready var ground = $".."  # Adjusted path

func _ready():
	if not ground:
		print("ERROR: StaticBody2D not found!")

func _on_HitBoxGround_body_entered(body):
	if body.name == "Player":
		print("Player stepped on breakable ground!")  
		ground.queue_free()  # Remove ground


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
