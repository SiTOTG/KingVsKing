class_name Tower
extends StaticBody2D

var target: Creature:
	set(value):
		target = value
		if is_instance_valid(target):
			update_target()
		else:
			attack_path.clear_points()

var deltas: PackedVector2Array = PackedVector2Array()

@onready var enemy_detector = $EnemyDetector
@onready var attack_timer = $AttackTimer
@onready var attack_path = $AttackPath
@onready var projectile_origin = $ProjectileOrigin

@export var curve: Curve
@export var samples: int = 20
@export var height: float = 30.0

var projectile_scene: PackedScene = load("res://projectiles/projectile.tscn")

func _ready():
	if ProjectSettings.get("debug/settings/events/show_trajectories"):
		attack_path.visible = true

	for i in range(samples):
		var progress = 1.0*i/samples
		var delta = curve.sample(progress)
		deltas.append(Vector2(0, -delta*height))

func _on_attack_timer_timeout():
	attack()

func attack():
	if not is_instance_valid(target):
		target = null
		attack_timer.stop()
		return
	var projectile = projectile_scene.instantiate()
	projectile.path = attack_path.points.duplicate()
	projectile.deltas = deltas
	projectile.target = target
	projectile.height = height
	projectile.position = projectile_origin.position
	projectile.translate(global_position)
	get_tree().current_scene.add_child(projectile)
	projectile.fly()

func find_target() -> bool:
	var possible_targets: Array = enemy_detector.get_overlapping_areas()
	if len(possible_targets) == 0:
		return false
	target = possible_targets[0].get_parent()
	return true

func _physics_process(delta):
	if is_instance_valid(target):
		update_path()
	else:
		find_target()

func _on_enemy_detector_area_entered(area):
	if not is_instance_valid(target):
		target = area.get_parent()

func update_target():
	if attack_timer.is_stopped():
		attack()
		attack_timer.start()

func update_path():
	attack_path.clear_points()
	attack_path.add_point(projectile_origin.position)
	var vector_to_target = target.global_position - projectile_origin.global_position

	for i in range(samples):
		var progress = 1.0*i/samples
		var delta = curve.sample(progress)
		var progress_vector = projectile_origin.position + vector_to_target*progress
		attack_path.add_point(Vector2(progress_vector.x, progress_vector.y - delta*height))

func _on_enemy_detector_area_exited(area):
	if area.get_parent() == target:
		if not find_target():
			target = null
