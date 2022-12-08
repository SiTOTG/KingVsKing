class_name Spawner
extends StaticBody2D

@export var creature_scene: PackedScene
@export var spawn_capacity := 100


@export_flags_2d_physics var enemy_layer = 0
@export_flags_2d_physics var friendly_layer = 0

@onready var spawn_position = $SpawnPosition
@onready var progress_bar = $ProgressBar
@onready var spawn_timer = $SpawnTimer
@onready var move_position = $MovePosition


var starting_move_position: Vector2
var spawned = 0

func _ready():
	if starting_move_position:
		move_position.global_position = starting_move_position

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
	get_tree().root.add_child(creature)
	spawned += 1


func decrease_spawned():
	spawned = max(0, spawned - 1)

func _on_spawn_timer_timeout():
	spawn()
