extends CenterContainer

@onready var start_game_button = %StartGameButton
@onready var Settings_button = %SettingsButton

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")
	
func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/SettingsMenu.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()
