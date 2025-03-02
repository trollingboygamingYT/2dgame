extends CanvasLayer

@onready var pause_menu = $Panel  # Reference to the Panel UI
@onready var pause_button = %Resume

func _ready():
	pause_menu.visible = false  # Hide pause menu at start
	process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure UI still works when paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Default ESC key in Godot
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false  # Unpause the game
		pause_menu.visible = false
	else:
		get_tree().paused = true  # Pause the game
		pause_menu.visible = true
		pause_button.grab_focus()  # Ensure focus is set for navigation

func _on_quit_pressed():
	get_tree().paused = false  # Ensure the game is unpaused before switching scenes
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")


func _on_resume_pressed():
	toggle_pause()
