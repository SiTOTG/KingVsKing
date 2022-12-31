extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_settings_button_pressed():
	$Settings.visible = true
