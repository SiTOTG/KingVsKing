extends Control

func _on_start_button_pressed():
	var error = get_tree().change_scene_to_file("res://world/world.tscn")
	if error:
		printerr("Could not load scene world!")


func _on_settings_button_pressed():
	$Settings.visible = true
