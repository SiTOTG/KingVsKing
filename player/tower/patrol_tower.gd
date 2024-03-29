extends StaticBody2D


@export_flags_2d_physics var enemy_layer = 0
@export_flags_2d_physics var friendly_layer = 0
@export var creature_scene: PackedScene
@onready var spawn_timer = $SpawnTimer
@onready var rally_point = $RallyPoint
@export var patrol_path: Array

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
	creature.global_position = rally_point + Vector2(randi_range(1,10), randi_range(1,10))
	creature.enemy_layer = enemy_layer
	creature.friendly_layer = friendly_layer
	creature.tree_exiting.connect(decrease_spawned)
	creature.collision_layer = 0
	creature.patrol_path = patrol_path
	creature.nav_mode = 1
	creature.patrol_point = 0
	creature.destination = patrol_path[0]
	get_parent().add_child(creature)
	spawned += 1

func decrease_spawned():
	spawned = max(0, spawned - 1)
	if spawn_timer.is_stopped:
		spawn_timer.start()
