extends StaticBody2D

@export var creature_scene: PackedScene
@export var spawn_capacity := 100
@export_node_path(Node2D) var move_position

@export_flags_2d_physics var enemy_layer = 0
@export_flags_2d_physics var friendly_layer = 0

@onready var spawn_position = $SpawnPosition
@onready var progress_bar = $ProgressBar
@onready var spawn_timer = $SpawnTimer

var spawned = 0

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
	if move_position:
		var move_position_node: Node2D = get_node_or_null(move_position) as Node2D
		if move_position_node:
			creature.destination = move_position_node.global_position
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
