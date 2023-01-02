extends Node2D

var path: PackedVector2Array
var deltas: PackedVector2Array
var target: Node2D
var height: float
var impact_distance: float = 10.0
var original_position: Vector2

var travel_time: float = 1
var damage: int = 50

@onready var trajectile = %Trajectile
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	if ProjectSettings.get("debug/settings/events/show_trajectories"):
		trajectile.visible = true

func fly():
	if path == null:
		printerr("Path undefined, cannot fly")
		return
	if not is_instance_valid(target):
		printerr("No target, cannot fly")
		return

	var enemy_position = target.global_position
	var samples = len(deltas)
	var current = 0
	original_position = global_position
	calculate_trajectile(current, samples)
	while current < samples and global_position.distance_to(target.global_position) > impact_distance:
		var next_point = trajectile.get_point_position(0)
		look_at(next_point)

		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", next_point, travel_time/samples)
		tween.play()
		trajectile.remove_point(0)
		await tween.finished
		current += 1
		if not is_instance_valid(target):
			queue_free()
			return
		if target.global_position != enemy_position:
			enemy_position = target.global_position
			calculate_trajectile(current, samples)
	impact()


func calculate_trajectile(current, total_samples):
	var vector_to_target = target.global_position - original_position
	trajectile.clear_points()
	for i in range(current, total_samples):
		var progress = 1.0*i/total_samples
		var delta = deltas[i]
		var progress_vector = original_position + vector_to_target*progress
		trajectile.add_point(progress_vector + delta)
	trajectile.add_point(target.global_position)

func impact():
	target.stats.hp -= damage
	animated_sprite_2d.play("impact")
	await animated_sprite_2d.animation_finished
	queue_free()
