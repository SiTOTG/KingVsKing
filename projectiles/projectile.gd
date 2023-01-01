extends Node2D

var path: PackedVector2Array
@onready var animated_sprite_2d = $AnimatedSprite2D

func fly():
	if path == null:
		printerr("Path undefined, cannot fly")
		return
	var tween = get_tree().create_tween()
	var current = global_position
	for next_point in path:
		tween.tween_callback(look_at.bind(next_point))
		tween.tween_property(self, "global_position", next_point, 0.02)
	tween.tween_callback(impact)

func impact():
	animated_sprite_2d.play("impact")
	await animated_sprite_2d.animation_finished
	queue_free()
