extends Area2D  # or StaticBody2D

var damage_duration = 3.0  # Total DoT duration
var tick_interval = 3.0  # Damage applied every second
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
	var time_elapsed = 0
	while time_elapsed < damage_duration:
		while get_tree().paused:  # If paused, wait until unpaused
			await get_tree().process_frame  

		await get_tree().create_timer(tick_interval, false).timeout  # Non-paused timer
		if get_tree().paused:  
			break  # Stop immediately when paused
		if is_instance_valid(body) and body.health > 0 and is_in_contact:  # Ensure player is still alive and in contact
			body.take_damage_enemy()
			time_elapsed += tick_interval
