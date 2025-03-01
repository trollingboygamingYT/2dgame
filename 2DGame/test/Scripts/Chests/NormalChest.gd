extends Area2D

@onready var open_sprite = $Open  # Get the "Open" Sprite2D
@onready var closed_sprite = $Closed  # Get the "Closed" Sprite2D
@onready var collision_shape = $CollisionShape2D  # Get collision size

@export var item_scene: PackedScene  # Drag your prefab here in the Inspector
@export var min_items: int = 1  # Minimum number of items to spawn
@export var max_items: int = 5  # Maximum number of items to spawn
@export var item_spacing: float = 30.0  # Space between items

var is_open = false  # Track the chest state

func _ready():
	open_sprite.visible = false  # Start with chest closed
	closed_sprite.visible = true

func _input(event):
	if event.is_action_pressed("interact") and has_overlapping_bodies() and not is_open:
		is_open = true  # Set chest to open
		open_sprite.visible = true
		closed_sprite.visible = false
		spawn_items()

		# Start the player's pickup cooldown
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				body.start_pickup_cooldown()
				break

func spawn_items():
	if item_scene == null:
		print("ERROR: No item scene assigned!")  # Debugging
		return
	
	var rng = RandomNumberGenerator.new()
	var item_count = rng.randi_range(min_items, max_items)  # Random amount of items
	
	print("Spawning", item_count, "items")  # Debugging

	# Get the chest's top position
	var chest_top = global_position.y - (collision_shape.shape.extents.y + 10)  # 10 is an extra offset to prevent overlap
	var start_position = Vector2(global_position.x, chest_top)  # Center the items on top of the chest

	for i in range(item_count):
		var item = item_scene.instantiate()
		if item == null:
			print("ERROR: Failed to instantiate item!")  # Debugging
			return
		
		get_parent().add_child(item)  # Add item to the scene
		
		# Spread out items in a row on top of the chest
		item.global_position = start_position + Vector2(i * item_spacing, 0)
		
		print("Item spawned at:", item.global_position)  # Debugging
