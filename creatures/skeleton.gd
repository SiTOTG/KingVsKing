extends Creature

@onready var animation_tree: AnimationTree = $AnimationTree

func _idle():
	if animation_tree.get("parameters/Movement/current_state") != "Idling":
		animation_tree.set("parameters/Movement/transition_request", "Idling")

func _move():
	if animation_tree.get("parameters/Movement/current_state") != "Walking":
		animation_tree.set("parameters/Movement/current", "Walking")

func _attack():
	if not animation_tree.get("parameters/AttackTrigger/active"):
		animation_tree.set("parameters/AttackTrigger/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _update_direction():
	var animation_direction = 1
	if direction.x < 0:
		animation_direction = -1
	animation_tree.set("parameters/IdleDirection/blend_position", animation_direction)
	animation_tree.set("parameters/WalkDirection/blend_position", animation_direction)
	if not animation_tree.get("parameters/AttackTrigger/active"):  # Can only change the attack direction if not attacking
		animation_tree.set("parameters/AttackDirection/blend_position", animation_direction)
