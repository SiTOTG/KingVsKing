extends StaticBody2D

var target: Creature:
	set(value):
		target = value
		if is_instance_valid(target):
			update_target()
		else:
			attack_point.global_position = rally_point.global_position


@export_flags_2d_physics var enemy_layer = 0
@export_flags_2d_physics var friendly_layer = 0
@export var creature_scene: PackedScene
@onready var enemy_detector = $EnemyDetector
@onready var spawn_timer = $SpawnTimer
@onready var rally_point = $RallyPoint
@onready var attack_point = $AttackPoint
@onready var patrol_path = $PatrolPath

var spawned : int = 0
@export var spawn_capacity : int = 3

func _on_spawn_timer_timeout(): 
	if spawned >= spawn_capacity:
		spawn_timer.stop()
	else:
		spawn()

func spawn():
	if spawned >= spawn_capacity:
		return
	if not creature_scene:
		printerr("No creature to spawn")
		return
	var creature: Creature = creature_scene.instantiate() as Creature
	if not creature:
		return
	creature.destination = attack_point.global_position
	creature.global_position = rally_point.global_position + Vector2(randi_range(1,10), randi_range(1,10))
	creature.enemy_layer = enemy_layer
	creature.friendly_layer = friendly_layer
	creature.tree_exiting.connect(decrease_spawned)
	creature.collision_layer = 0
	creature.patrol_path = patrol_path.points
	creature.nav_mode = 1
	creature.patrol_point = 0
	get_parent().add_child(creature)
	spawned += 1

func find_target() -> bool:
	var possible_targets: Array = enemy_detector.get_overlapping_areas()
	if len(possible_targets) == 0:
		return false
	target = possible_targets[0].get_parent()
	return true

func _physics_process(delta):
	if is_instance_valid(target):
		pass
	else:
		find_target()

func _on_enemy_detector_area_entered(area):
	if not is_instance_valid(target):
		target = area.get_parent()

func update_target():
	attack_point.global_transform = target.global_transform

func _on_enemy_detector_area_exited(area):
	if area.get_parent() == target:
		if not find_target():
			target = null

func decrease_spawned():
	spawned = max(0, spawned - 1)
	if spawn_timer.is_stopped:
		spawn_timer.start()
