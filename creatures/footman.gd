class_name Footman
extends CharacterBody2D

@export var destination: Vector2:
	set(value):
		destination = value
		if agent:
			agent.target_location = destination

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

var target = null

enum {
	IDLE, MOVING
}

func update_layer():
	enemy_detector.collision_mask = enemy_layer
	enemy_detector.collision_layer = friendly_layer

func _ready():
	agent.velocity_computed.connect(on_velocity_computed)
	agent.target_location = destination

func _physics_process(delta):
	if global_position.distance_to(destination) > 10:
		move(delta)
	else:
		animation_tree.set("parameters/Movement/current", IDLE)

func _unhandled_input(event):
	# TODO: Used only for debugging, remove later, when we have proper gameplay
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		destination = get_global_mouse_position()
	if event.is_action_pressed("ui_accept"):
		animation_tree.set("parameters/Attack/active", true)

func move(delta):
	var direction = global_position.direction_to(agent.get_next_location())
	animation_tree.set("parameters/IdleDirection/blend_position", direction)
	animation_tree.set("parameters/MoveDirection/blend_position", direction)
	animation_tree.set("parameters/AttackDirection/blend_position", direction)
	animation_tree.set("parameters/Movement/current", MOVING)

	agent.set_velocity(direction * 120)

func on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

func _on_enemy_detector_area_entered(area):
	if not is_instance_valid(area): return
	target = area
	destination = target.global_position
	attack_timer.start()

func _on_enemy_detector_area_exited(area):
	print("Enemy left area")


func _on_attack_timer_timeout():
	animation_tree.set("parameters/Attack/active", true)
