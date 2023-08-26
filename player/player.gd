class_name Player
extends Node

static var instance = self

@export var player_selection: Array[SelectableObject] = []
@export var focused: SelectableObject

signal changed_selection(old_selection: Array[SelectableObject], new_selection: Array[SelectableObject])

func _ready():
	instance = self

func try_select(selectable_objects: Array[SelectableObject]) -> bool:
	var old_selection = player_selection
	player_selection = selectable_objects
	changed_selection.emit(old_selection, player_selection)
	return true

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT and player_selection:
			var old_selection = player_selection
			player_selection = []
			changed_selection.emit(old_selection, player_selection)


func _on_changed_selection(old_selection, new_selection):
	print("Old slection: ", old_selection, "; New selection: ", new_selection)
