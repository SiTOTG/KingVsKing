class_name Footman
extends CharacterBody2D

@export var destination: Vector2

@export var stats: CreatureStats
@export_flags_2d_physics var enemy_layer = 0:
	set(value):
		enemy_layer = value
		update_layer.call_deferred()
@export_flags_2d_physics var friendly_layer = 0:
	set(value):
		friendly_layer = value
		update_layer.call_deferred()

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var enemy_detector: Area2D = $EnemyDetector
@onready var attack_timer: Timer = $AttackTimer
@onready var value_bar: ValueBar = $ValueBar

var direction := Vector2.DOWN:
	set(value):
		if animation_tree:
			direction = value
			_update_direction()
var target = null

enum {
	IDLE, MOVING
}

func update_layer():
	enemy_detector.collision_mask = enemy_layer
	enemy_detector.collision_layer = friendly_layer

func _ready():
	stats = stats.duplicate()
	agent.velocity_computed.connect(on_velocity_computed)
	agent.target_location = destination
	stats.hp_updated.connect(
		func(previous_hp: int, new_hp: int, max_hp: int):
			value_bar.animate_bar(new_hp, max_hp)
	)
	value_bar.set_bar(stats.hp, stats.max_hp)

func _physics_process(_delta):
	if global_position.distance_to(destination) > 10:
		move()
	else:
		animation_tree.set("parameters/Movement/current", IDLE)

func _unhandled_input(event):
	# TODO: Used only for debugging, remove later, when we have proper gameplay
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		destination = get_global_mouse_position()
		if not is_instance_valid(target):
			agent.target_location = destination
	if event.is_action_pressed("ui_accept"):
		animation_tree.set("parameters/Attack/active", true)

func move():
	direction = global_position.direction_to(agent.get_next_location())
	animation_tree.set("parameters/Movement/current", MOVING)
	agent.set_velocity(direction * 120)

func on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

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

func _on_attack_timer_timeout():
	direction = global_position.direction_to(target.global_position)
	animation_tree.set("parameters/Attack/active", true)

func _update_direction():
	animation_tree.set("parameters/IdleDirection/blend_position", direction)
	animation_tree.set("parameters/MoveDirection/blend_position", direction)
	if not animation_tree.get("parameters/Attack/active"):  # Can only change the attack direction if not attacking
		animation_tree.set("parameters/AttackDirection/blend_position", direction)

func damage_target():
	if is_instance_valid(target) and "stats" in target.get_parent():
		var target_stats = target.get_parent().stats as CreatureStats
		if not target_stats: return
		target_stats.hp -= 5
