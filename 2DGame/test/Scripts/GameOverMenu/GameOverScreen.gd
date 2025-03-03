extends CanvasLayer

@onready var game_over_screen = $GameOverScreen
@onready var respawn_button = $GameOverScreen/Respawn
@onready var quit_button = $GameOverScreen/Quit

func _ready():
	# Hide the Game Over screen at start
	game_over_screen.visible = false
	# Connect buttons
	respawn_button.pressed.connect(_on_respawn_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_game_over():
	game_over_screen.visible = true  # Show the Game Over screen

func _on_respawn_pressed():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.respawn()
	game_over_screen.visible = false  # Hide Game Over screen

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")  # Load start menu
