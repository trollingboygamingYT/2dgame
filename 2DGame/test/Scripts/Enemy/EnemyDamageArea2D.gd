extends Area2D  # or StaticBody2D

var damage_duration = 3.0  # Duration of DOT effect
var tick_interval = 1.0  # Damage applied every second

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage_enemy()  # Initial hit
		apply_dot(body)

func apply_dot(body):
	var time_elapsed = 0
	while time_elapsed < damage_duration:
		await get_tree().create_timer(tick_interval).timeout
		if body and body.health > 0:  # Ensure player is still alive
			body.take_damage_enemy()
			time_elapsed += tick_interval
