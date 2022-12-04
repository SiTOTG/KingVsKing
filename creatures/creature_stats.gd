class_name CreatureStats
extends Resource

signal hp_updated(previous_hp: int, new_hp: int, max_hp: int)

@export var hp = 100:
	set(value):
		var previous_hp = hp
		hp = clampi(value, 0, max_hp)
		hp_updated.emit(previous_hp, hp, max_hp)
@export var max_hp = 100

func _init():
	hp = max_hp
