extends Area2D

var card: Card
var tower#: Tower

var preview: Node2D
var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.start_card_activation_event.connect(_show_tower)
	Events.finish_card_activation_event.connect(_hide_tower)

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
	if "tower_scene" in card:
		tower = load(card.tower_scene)
		var t = tower.instantiate()
		self.add_child(t)

func _hide_tower():
	if is_instance_valid(preview):
		preview.queue_free()
		$AnimationPlayer.stop()

func _on_mouse_entered():
	if card:
		card.hovering_tower_slot = self
	hovering = true
	_show_tower(card)

func _on_mouse_exited():
	if is_instance_valid(card):
		card.hovering_tower_slot = null
	hovering = false
	_hide_tower()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if hovering == true:
				_build_tower(card)
