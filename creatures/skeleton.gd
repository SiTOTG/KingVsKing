extends Creature

@onready var animation_tree: AnimationTree = $AnimationTree

func _idle():
	animation_tree.set("parameters/MoveState/current", IDLE)

func _move():
	animation_tree.set("parameters/MoveState/current", MOVING)

func _attack():
	animation_tree.set("parameters/AttackTrigger/active", true)

func _update_direction():
	var animation_direction = 1
	if direction.x < 0:
		animation_direction = -1
	animation_tree.set("parameters/IdleDirection/blend_position", animation_direction)
	animation_tree.set("parameters/WalkDirection/blend_position", animation_direction)
	if not animation_tree.get("parameters/AttackTrigger/active"):  # Can only change the attack direction if not attacking
		animation_tree.set("parameters/AttackDirection/blend_position", animation_direction)
