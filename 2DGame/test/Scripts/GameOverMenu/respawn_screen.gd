extends Control

func _on_respawn_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Overworld.tscn")



func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
