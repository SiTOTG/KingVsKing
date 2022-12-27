extends StaticBody2D

signal destroyed

@export var stats: BuildingStats = preload("res://world/default_home.tres")

@export_flags_2d_physics var enemy_layer = 0
@export_flags_2d_physics var friendly_layer = 0

@onready var hp_bar: ValueBar = $HPBar
@onready var area_2d = $Area2D

func _ready():
	stats = stats.duplicate()

	stats.hp_updated.connect(
		func(previous_hp: int, new_hp: int, max_hp: int):
			hp_bar.animate_bar(new_hp, max_hp)
			if new_hp == 0:
				destroyed.emit()
				queue_free()
	)
	hp_bar.set_bar.call_deferred(stats.hp, stats.max_hp)
	
	area_2d.collision_layer = friendly_layer
	area_2d.collision_mask = enemy_layer
