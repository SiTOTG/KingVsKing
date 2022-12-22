extends Sprite2D

var active_card: Card

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.start_card_activation_event.connect(_on_card_activation_started)
	Events.finish_card_activation_event.connect(_on_card_activation_finished)
	Events.hover_tile_event.connect(
		func(hovered_tile_position: Vector2):
			global_position = hovered_tile_position
	)
	hide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if active_card and active_card.ctx == Card.SPAWNER:
				Events.confirm_card_activation_event.emit()
				get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT and active_card:
			active_card.active = false
			Events.cancel_card_activation_event.emit()

func _on_card_activation_started(card: Card):
	active_card = card
	show()
	update_texture(Card.NO_TARGET)
	active_card.context_changed.connect(_on_card_context_changed)

func _on_card_activation_finished():
	if not active_card: return
	active_card.context_changed.disconnect(_on_card_context_changed)
	hide()

func _on_card_context_changed(old_context: int, new_context: int):
	update_texture(new_context)

func update_texture(context: int):
	match context:
		Card.NO_TARGET:
			texture = active_card.mouse_empty
			scale = Vector2(0.35, 0.35)
			modulate.a = 1
		Card.RESET:
			texture = null
			scale = Vector2(0.35, 0.35)
			modulate.a = 1
		Card.SPAWNER:
			texture = active_card.mouse_build
			scale = Vector2(0.232, 0.232)
			self_modulate.a = 0.4
