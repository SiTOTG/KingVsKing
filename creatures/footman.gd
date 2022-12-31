extends Creature

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sfx = $SwordSFX

func _idle():
	animation_tree.set("parameters/Movement/current", IDLE)

func _move():
	animation_tree.set("parameters/Movement/current", MOVING)

func _attack():
	animation_tree.set("parameters/Attack/active", true)
	sfx.play()

func _update_direction():
	animation_tree.set("parameters/IdleDirection/blend_position", direction)
	animation_tree.set("parameters/MoveDirection/blend_position", direction)
	if not animation_tree.get("parameters/Attack/active"):  # Can only change the attack direction if not attacking
		animation_tree.set("parameters/AttackDirection/blend_position", direction)
