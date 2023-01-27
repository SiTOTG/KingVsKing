class_name Creature
extends CharacterBody2D

@export var destination: Vector2
@export var patrol_point: int = 0
@export var patrol_path: Array

@export var stats: CreatureStats
@export_enum("Rally", "Patrol") var nav_mode: int = RALLY
@export_flags_2d_physics var enemy_layer = 0:
	set(value):
		enemy_layer = value
		update_layer.call_deferred()
@export_flags_2d_physics var friendly_layer = 0:
	set(value):
		friendly_layer = value
		update_layer.call_deferred()

@onready var agent: NavigationAgent2D = %NavigationAgent2D
@onready var enemy_detector: Area2D = $EnemyDetector
@onready var attack_timer: Timer = $AttackTimer
@onready var value_bar: ValueBar = $ValueBar

var direction := Vector2.DOWN:
	set(value):
		direction = value
		_update_direction()

var target = null

enum {
	IDLE, MOVING
}

enum {
	RALLY, PATROL
}

func update_layer():
	if not enemy_detector: return
	enemy_detector.collision_mask = enemy_layer
	enemy_detector.collision_layer = friendly_layer

func _ready():
	stats = stats.duplicate()
	var _error = agent.velocity_computed.connect(on_velocity_computed)
	agent.target_location = destination
	_error = stats.hp_updated.connect(
		func(_previous_hp: int, new_hp: int, max_hp: int):
			value_bar.animate_bar(new_hp, max_hp)
			if new_hp == 0:
				queue_free()
	)
	value_bar.set_bar(stats.hp, stats.max_hp)
	value_bar.visible = GlobalSettings.show_creature_ui
	_error = GlobalSettings.creature_ui_visibility_changed.connect(
		func(value):
			value_bar.visible = value
	)
	

func _physics_process(_delta):
	if nav_mode == RALLY:
		if not is_instance_valid(target) and agent.target_location != destination:
			agent.target_location = destination
		if global_position.distance_to(agent.target_location) > 10:
			move()
		else:
			_idle()
	if nav_mode == PATROL:
		if not is_instance_valid(target):
			# Check if we reached a waypoint
			if global_position.distance_to(agent.target_location) < 5:
				patrol_point = (patrol_point + 1) % patrol_path.size()
				destination = patrol_path[patrol_point]
				agent.target_location = destination
			move()

func _idle():
	pass

func move():
	_move()
	direction = global_position.direction_to(agent.get_next_location())
#	agent.set_velocity(direction * stats.speed)
	on_velocity_computed(direction * stats.speed)
	
func patrol():
	pass

func _move():
	pass

func on_velocity_computed(safe_velocity: Vector2):
	direction = safe_velocity.normalized()
	velocity = direction * stats.speed
	var _collided = move_and_slide()

func _on_enemy_detector_area_entered(area):
	if is_instance_valid(target): return
	retarget(area)

func retarget(new_target):
	if not is_instance_valid(new_target): return
	target = new_target

	agent.target_location = target.global_position
	attack_timer.start()

func _on_enemy_detector_area_exited(area):
	if area == target:
		var enemies = enemy_detector.get_overlapping_areas()
		if len(enemies) > 0:
			retarget(enemies[0])

func retarget_find_target() -> bool:
	var enemies = enemy_detector.get_overlapping_areas()
	if len(enemies) > 0:
		retarget(enemies[0])
		return true
	return false

func _on_attack_timer_timeout():
	if not is_instance_valid(target):
		if not retarget_find_target(): return
	direction = global_position.direction_to(target.global_position)
	damage_target()
	_attack()

func _attack():
	pass

func _update_direction():
	pass

func damage_target():
	if is_instance_valid(target) and "stats" in target.get_parent():
		var target_stats = target.get_parent().stats
		if "hp" in target_stats:
			target_stats.hp -= 5
