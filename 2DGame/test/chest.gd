extends Area2D

@onready var open_sprite = $Open  # Get the "Open" Sprite2D
@onready var closed_sprite = $Closed  # Get the "Closed" Sprite2D

var is_open = false  # Track the chest state

func _ready():
	open_sprite.visible = false  # Start with chest closed

func _input(event):
	if event.is_action_pressed("interact") and has_overlapping_bodies():
		is_open = !is_open  # Toggle open/closed state
		open_sprite.visible = is_open
		closed_sprite.visible = !is_open
