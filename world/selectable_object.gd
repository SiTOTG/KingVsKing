class_name SelectableObject
extends Area2D

var player: Player

signal selected
signal unselected

func has_player():
	if not is_instance_valid(player):
		player = Player.instance as Player
		player.changed_selection.connect(_on_player_changed_selection)
	return is_instance_valid(player)

func _on_mouse_entered():
	if has_player():
		player.focused = self

func _on_mouse_exited():
	if has_player() and player.focused == self:
		player.focused = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if has_player() and player.focused == self:
			if player.try_select([self]):
				selected.emit()

func _on_player_changed_selection(old_selection: Array[SelectableObject], new_selection: Array[SelectableObject]):
	if self in old_selection and not self in new_selection:
		unselected.emit()

func _exit_tree():
	if has_player() and self in player.player_selection:
		var new_selection = player.player_selection.duplicate()
		new_selection.erase(self)
		player.try_select(new_selection)
