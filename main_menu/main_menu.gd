extends Control

func _on_start_button_pressed():
	print("Called")
	get_tree().change_scene_to_file("res://world/world.tscn")
