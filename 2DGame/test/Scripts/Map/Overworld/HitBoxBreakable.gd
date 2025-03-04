extends Area2D

@onready var ground = $".."  # Adjusted path
@onready var color_rect = $CollisionShape2D/BreakableColor # Adjusted path

func _ready():
	if not ground:
		print("ERROR: StaticBody2D not found!")
	if not color_rect:
		print("ERROR: BreakableColor not found!")

func _on_HitBoxGround_body_entered(body):
	if body.name == "Player":
		print("Player stepped on breakable ground!")  
		ground.queue_free()  # Remove ground
		color_rect.visible = false  # Hide the ColorRect
