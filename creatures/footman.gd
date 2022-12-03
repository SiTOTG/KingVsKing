class_name Footman
extends CharacterBody2D

@export var destination: Vector2:
	set(value):
		destination = value
		if agent:
			agent.target_location = destination
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var agent: NavigationAgent2D = $NavigationAgent2D

enum {
	IDLE, MOVING
}

func _ready():
	agent.velocity_computed.connect(on_velocity_computed)
	agent.target_location = destination

func _physics_process(_delta):
	if global_position.distance_to(destination) > 10:
		move()
	else:
		animation_tree.set("parameters/Movement/current", IDLE)

func _unhandled_input(event):
	# TODO: Used only for debugging, remove later, when we have proper gameplay
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		destination = get_global_mouse_position()
	if event.is_action_pressed("ui_accept"):
		animation_tree.set("parameters/Attack/active", true)

func move():
	var direction = global_position.direction_to(agent.get_next_location())
	animation_tree.set("parameters/IdleDirection/blend_position", direction)
	animation_tree.set("parameters/MoveDirection/blend_position", direction)
	animation_tree.set("parameters/AttackDirection/blend_position", direction)
	animation_tree.set("parameters/Movement/current", MOVING)

	velocity = direction * 120
	move_and_slide()

func on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity*120
	move_and_slide()
