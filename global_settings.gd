extends Node

signal creature_ui_visibility_changed(value)

var show_creature_ui: bool = true:
	set(value):
		show_creature_ui = value
		creature_ui_visibility_changed.emit(value)
