class_name BuildingStats
extends Resource

signal hp_updated(previous_hp: int, new_hp: int, max_hp: int)

@export var max_hp = 400
@export var hp := 400:
	set(value):
		var previous_hp = hp
		hp = clampi(value, 0, max_hp)
		hp_updated.emit(previous_hp, hp, max_hp)
