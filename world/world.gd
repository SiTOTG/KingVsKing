extends Node2D

@onready var destination_lane_1 = $DestinationLane1

func _unhandled_input(event):
	if event.is_action_pressed("toggle_creature_ui"):
		GlobalSettings.show_creature_ui = not GlobalSettings.show_creature_ui


func _on_card_hud_create_spawner(position: Vector2, spawner_scene: PackedScene):
	var spawner = spawner_scene.instantiate() as Spawner
	spawner.global_position = position
	spawner.starting_move_position = destination_lane_1.global_position
	add_child(spawner)
