extends Node2D

@onready var skeleton: Creature = $Skeleton

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed:
		skeleton.destination = get_global_mouse_position()
		skeleton.agent.target_location = get_global_mouse_position()

func _ready():
	Bgm.stop()
