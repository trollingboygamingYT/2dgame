# IS ALLES VOOR DAMAGE EN DoT
extends Area2D

var damage_duration = 3.0  # Total DoT duration
var tick_interval = 1.5  # Damage applied every second
var is_in_contact = false  # To track if player is in contact with enemy
var dot_timer = null  # Timer for DoT ticks
var player_body = null  # Reference to the player body
var dot_start_delay = 0.2  # Delay before DoT starts (in seconds)
var is_dot_active = false  # To track if DoT is currently active
var dot_start_timer = null  # Timer for the delay before DoT starts

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE  # Stops processing when paused
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_in_contact = true
		player_body = body
		start_dot_delay()

func _on_body_exited(body):
	if body.is_in_group("player"):
		is_in_contact = false
		stop_dot_delay()
		stop_dot()

func start_dot_delay():
	# Cancel any existing delay timer
	if dot_start_timer != null:
		dot_start_timer.stop()
		dot_start_timer.queue_free()
		dot_start_timer = null

	# Start a new delay timer
	dot_start_timer = Timer.new()
	dot_start_timer.wait_time = dot_start_delay
	dot_start_timer.one_shot = true
	dot_start_timer.connect("timeout", Callable(self, "_on_dot_delay_timeout"))
	add_child(dot_start_timer)
	dot_start_timer.start()

func stop_dot_delay():
	# Cancel the delay timer if it exists
	if dot_start_timer != null:
		dot_start_timer.stop()
		dot_start_timer.queue_free()
		dot_start_timer = null

func _on_dot_delay_timeout():
	# Start the DoT after the delay if the player is still in contact
	if is_in_contact and is_instance_valid(player_body):
		start_dot()

func start_dot():
	if dot_timer == null:
		dot_timer = Timer.new()
		dot_timer.wait_time = tick_interval
		dot_timer.one_shot = false
		dot_timer.connect("timeout", Callable(self, "_on_dot_tick"))
		add_child(dot_timer)
		dot_timer.start()
		is_dot_active = true
		player_body.take_damage_enemy()  # Initial hit

func stop_dot():
	if dot_timer != null:
		dot_timer.stop()
		dot_timer.queue_free()
		dot_timer = null
		is_dot_active = false

func _on_dot_tick():
	if is_in_contact and is_instance_valid(player_body) and player_body.health > 0:
		player_body.take_damage_enemy()
	else:
		stop_dot()
