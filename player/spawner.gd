class_name Spawner
extends Area2D

@export var creature_scene: PackedScene
@export var spawn_capacity := 100
@export var stats: SpawnerStats = preload("res://player/spawner_stats.tres")

@export_flags_2d_physics var enemy_layer = 0
@export_flags_2d_physics var friendly_layer = 0

@onready var spawn_position = $SpawnPosition
@onready var progress_bar = $ProgressBar
@onready var spawn_timer = $SpawnTimer
@onready var move_position = $MovePosition
@onready var collision_shape = $CollisionShape2D
@onready var hp_bar: ValueBar = $HPBar

var starting_move_position: Vector2
var spawned = 0

func _ready():
	if starting_move_position:
		move_position.global_position = starting_move_position
	stats = stats.duplicate()

	stats.hp_updated.connect(
		func(_previous_hp: int, new_hp: int, max_hp: int):
			hp_bar.animate_bar(new_hp, max_hp)
			if new_hp == 0:
				queue_free()
	)
	hp_bar.set_bar.call_deferred(stats.hp, stats.max_hp)

func _process(_delta):
	progress_bar.value = (1 - (spawn_timer.time_left / spawn_timer.wait_time))*100

func spawn():
	if spawned >= spawn_capacity:
		return
	if not creature_scene:
		printerr("No creature to spawn")
		return
	var creature: Creature = creature_scene.instantiate() as Creature
	if not creature:
		return
	creature.destination = move_position.global_position
	creature.global_position = spawn_position.global_position
	creature.enemy_layer = enemy_layer
	creature.friendly_layer = friendly_layer
	creature.tree_exited.connect(decrease_spawned)
	get_parent().add_child(creature)
	spawned += 1

func get_polygon() -> PackedVector2Array:
	var shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
	var rect = shape.get_rect()
	var pos = to_global(rect.position)
	var vertices = PackedVector2Array([pos, pos + Vector2(rect.size.x, 0), pos + rect.size, pos + Vector2(0, rect.size.y), pos])
	return vertices

func decrease_spawned():
	spawned = max(0, spawned - 1)

func _on_spawn_timer_timeout():
	spawn()
