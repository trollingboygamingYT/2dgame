extends Area2D

@onready var full_potion = $FullObject  # Ensure this exists in the scene
@export var float_speed: float = 2  # Speed of floating motion
@export var float_amplitude: float = 4  # How far it moves up and down
@export var pickup_cooldown: float = 1.0  # Cooldown time in seconds

var base_position: Vector2
var time_passed: float = 0.0
var can_pickup: bool = true

func _ready():
	add_to_group("potions")  # Add this potion to the "potions" group
	base_position = global_position  # Store the initial position

func _process(delta):
	time_passed += delta * float_speed
	global_position.y = base_position.y + sin(time_passed) * float_amplitude

func _on_body_entered(body):
	if body.is_in_group("player") and not body.has_potion and can_pickup:
		body.pickup_potion(self)  # Pass the potion to the player for pickup
		can_pickup = false  # Disable pickup
		start_cooldown()  # Start the cooldown timer
		queue_free()  # Remove potion immediately after pickup

func start_cooldown():
	# Start a timer to re-enable pickup after the cooldown period
	var cooldown_timer = Timer.new()
	cooldown_timer.wait_time = pickup_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timeout)  # Correctly connect using Callable
	add_child(cooldown_timer)
	cooldown_timer.start()

func _on_cooldown_timeout():
	can_pickup = true  # Re-enable pickup after cooldown
