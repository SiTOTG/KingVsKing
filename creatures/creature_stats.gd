class_name CreatureStats
extends Resource

signal hp_updated(previous_hp: int, new_hp: int, max_hp: int)

@export_group("State")
@export var hp = 100:
	set(value):
		var previous_hp = hp
		hp = clampi(value, 0, max_hp)
		hp_updated.emit(previous_hp, hp, max_hp)

@export_group("Props")
@export var max_hp = 100
@export var speed = 120

func _init():
	hp = max_hp
