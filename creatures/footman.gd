extends CharacterBody2D

@export var destination: Vector2
@onready var animation_tree: AnimationTree = $AnimationTree

func _physics_process(_delta):
	if global_position.distance_to(destination) > 10:
		move()
	else:
		animation_tree.set("parameters/Movement/current", 0)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		destination = get_global_mouse_position()

func move():
	var direction = global_position.direction_to(destination)
	animation_tree.set("parameters/IdleDirection/blend_position", direction)
	animation_tree.set("parameters/MoveDirection/blend_position", direction)
	animation_tree.set("parameters/Movement/current", 1)
	
	velocity = direction * 150
	move_and_slide()
