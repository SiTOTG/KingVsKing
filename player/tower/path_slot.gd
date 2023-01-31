extends Area2D

var card: Card

var preview: Node2D
var hovering = false



enum {
	PATROLTOWER, TRAP
}

@export_enum("Patrol Tower", "Trap") var tower_type: int = PATROLTOWER
@onready var tower = $Tower

signal tower_created

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.start_card_activation_event.connect(_show_tower)
	Events.finish_card_activation_event.connect(_on_finish_card_activation)
	Events.confirm_card_activation_event.connect(_on_card_activation)

func _show_tower(card: Card):
	if not is_instance_valid(card):
		return
	self.card = card
	if hovering:
		card.hovering_tower_slot = self
		preview = card.mouse_tower_preview.instantiate()
		preview.name = "Preview"
		add_child(preview)
		var animation: Animation = $AnimationPlayer.get_animation("show_preview")
		animation.track_set_path(0, "Preview:modulate")
		$AnimationPlayer.play("show_preview")

func _build_tower(card: Card):
	if is_instance_valid(card):
		if "tower_scene" in card:
			if not is_instance_valid(tower):
				tower = load(card.tower_scene)
				var t = tower.instantiate()
				t.name = "Tower"
				self.add_child(t)
				emit_signal("tower_created")

func _hide_tower():
	if is_instance_valid(preview):
		preview.queue_free()
		$AnimationPlayer.stop()

func _on_mouse_entered():
	print("hover")
	if card:
		card.hovering_tower_slot = self
	hovering = true
	_show_tower(card)

func _on_mouse_exited():
	print("unhover")
	if is_instance_valid(card):
		card.hovering_tower_slot = null
	hovering = false
	_hide_tower()

func _on_finish_card_activation():
	card = null
	_hide_tower()

func _on_card_activation():
	if hovering == true:
		_build_tower(card)
