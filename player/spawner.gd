extends StaticBody2D

@export var creature_scene: PackedScene
@export var spawn_capacity := 100
@export_node_path(Node2D) var target_position

@onready var spawn_position = $SpawnPosition
@onready var progress_bar = $ProgressBar
@onready var spawn_timer = $SpawnTimer

var spawned = 0

func _process(delta):
	progress_bar.value = (1 - (spawn_timer.time_left / spawn_timer.wait_time))*100

func spawn():
	if spawned >= spawn_capacity:
		return
	if not creature_scene:
		printerr("No creature to spawn")
		return
	var creature: Footman = creature_scene.instantiate() as Footman
	if not creature:
		return
	if target_position:
		var target_position_node: Node2D = get_node_or_null(target_position) as Node2D
		if target_position_node:
			creature.destination = target_position_node.global_position
	creature.global_position = spawn_position.global_position

	creature.tree_exited.connect(decrease_spawned)
	get_tree().root.add_child(creature)
	spawned += 1


func decrease_spawned():
	spawned = max(0, spawned - 1)

func _on_spawn_timer_timeout():
	spawn()
