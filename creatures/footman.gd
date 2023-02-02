extends Creature

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sfx = $SwordSFX

func _idle():
	if animation_tree.get("parameters/Movement/current_state") != "Idling":
		animation_tree.set("parameters/Movement/transition_request", "Idling")

func _move():
	if animation_tree.get("parameters/Movement/current_state") != "Moving":
		animation_tree.set("parameters/Movement/current", "Moving")

func _attack():
	if not animation_tree.get("parameters/Attack/active"):
		animation_tree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	sfx.play()

func _update_direction():
	animation_tree.set("parameters/IdleDirection/blend_position", direction)
	animation_tree.set("parameters/MoveDirection/blend_position", direction)
	if not animation_tree.get("parameters/Attack/active"):  # Can only change the attack direction if not attacking
		animation_tree.set("parameters/AttackDirection/blend_position", direction)
