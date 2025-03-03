extends Area2D  # or StaticBody2D

var damage_duration = 3.0  # Total DoT duration
var tick_interval = 2  # Damage applied every second
var is_in_contact = false  # To track if player is in contact with enemy

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE  # Stops processing when paused
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_in_contact = true
		body.take_damage_enemy()  # Initial hit
		apply_dot(body)

func _on_body_exited(body):
	if body.is_in_group("player"):
		is_in_contact = false  # Player left the collision area
		
func apply_dot(body):
	await get_tree().create_timer(tick_interval, false).timeout  # Initial delay

	while is_instance_valid(body) and body.health > 0:  # Keep running as long as the player is valid
		while get_tree().paused:  
			await get_tree().process_frame  

		if not is_in_contact:  
			break  # Stop applying DoT if the player left

		body.take_damage_enemy()
		await get_tree().create_timer(tick_interval, false).timeout  # Wait before next tick
