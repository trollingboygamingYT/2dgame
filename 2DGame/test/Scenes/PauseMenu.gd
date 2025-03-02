extends CanvasLayer

@onready var pause_menu = $Panel  # Reference to the Panel UI
@onready var pause_button = %Pause

func _ready():
	pause_menu.visible = false  # Hide pause menu at start

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Default ESC key in Godot
		pause_button.grab_focus()
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused  # Toggle pause state
	pause_menu.visible = get_tree().paused  # Show/hide UI

func _on_quit_pressed():
	get_tree().quit()


func _on_pause_pressed():
	toggle_pause()
