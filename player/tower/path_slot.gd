extends Area2D

var card: Card

var preview: Node2D
var hovering = false

@onready var building = $Building
@onready var patrol_path = $PatrolPath

signal pathbuild_created

func _ready():
	Events.start_card_activation_event.connect(_show_tower)
	Events.finish_card_activation_event.connect(_on_finish_card_activation)
	Events.confirm_card_activation_event.connect(_on_card_activation)

func _show_tower(card: Card):
	if not is_instance_valid(card):
		return
	self.card = card
	if hovering:
		card.hovering_path_slot = self
		preview = card.mouse_path_preview.instantiate()
		preview.name = "Preview"
		add_child(preview)
		var animation: Animation = $AnimationPlayer.get_animation("show_preview")
		animation.track_set_path(0, "Preview:modulate")
		$AnimationPlayer.play("show_preview")

func _build_path(card: Card):
	if is_instance_valid(card):
		if "path_scene" in card:
			if not is_instance_valid(building):
				building = load(card.path_scene)
				var b = building.instantiate()
				b.name = "PathBuilding"
				if card.path_type == Card.PATROLTOWER:
					var points = []
					for point in patrol_path.points:
						points.append(point + global_position)
					b.patrol_path = points
					b.rally_point.position = self.global_position + Vector2(0, 10)
				self.add_child(b)
				emit_signal("pathbuild_created")

func _hide_tower():
	if is_instance_valid(preview):
		preview.queue_free()
		$AnimationPlayer.stop()

func _on_mouse_entered():
	if card:
		card.hovering_path_slot = self
	hovering = true
	_show_tower(card)

func _on_mouse_exited():
	if is_instance_valid(card):
		card.hovering_path_slot = null
	hovering = false
	_hide_tower()

func _on_finish_card_activation():
	card = null
	_hide_tower()

func _on_card_activation():
	if hovering == true:
		_build_path(card)
