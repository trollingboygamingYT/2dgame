extends Area2D

func _on_body_entered(_body):
	call_deferred("change_scene")

func change_scene():
	get_tree().change_scene_to_file("res://Scenes/VillageOverWorld.tscn")
