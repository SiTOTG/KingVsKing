extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("toggle_creature_ui"):
		GlobalSettings.show_creature_ui = not GlobalSettings.show_creature_ui
