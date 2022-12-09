extends CanvasLayer

@export_node_path("TileMap") var tilemap_master

@onready var cardsPanel = $CardsPanel
@onready var expand = $Expand
@onready var cards = %Cards


var held_card: Card = null
var _tilemap_master: TilemapMaster
var held_card_sprite: Sprite2D

signal create_spawner(position: Vector2, spawner_scene: PackedScene)

enum {
	RESET,
	NO_TARGET,
	SPAWNER
}

var ctx: int = RESET

func _ready():
	show()
	cardsPanel.hide()
	expand.show()
	_tilemap_master = get_node(tilemap_master)

	connect_signals()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if held_card and ctx == SPAWNER and _tilemap_master.can_build_there():
				var spawner = load(held_card.spawner_scene) as PackedScene
				create_spawner.emit(_tilemap_master.get_origin_position(), spawner)
				_tilemap_master.set_tiles_as_blocked()
				Events.finish_card_activation.emit()
				if not Input.is_physical_key_pressed(KEY_SHIFT):
					release_card()
		elif event.button_index == MOUSE_BUTTON_RIGHT and held_card:
			release_card()
			Events.cancel_card_activation.emit()

func _physics_process(delta):
	if held_card and held_card_sprite:
		held_card_sprite.global_position = held_card_sprite.get_global_mouse_position()
		update_ctx()

func update_ctx():
	if not held_card:
		ctx = RESET
		return
	if _tilemap_master.is_over_tile():
		if ctx != SPAWNER:
			ctx = SPAWNER
			held_card_sprite.texture = held_card.mouse_build
			held_card_sprite.scale = Vector2(0.232, 0.232)
			held_card_sprite.self_modulate.a = 0.4
		held_card_sprite.global_position = _tilemap_master.get_origin_position()
	elif ctx != NO_TARGET:
		ctx = NO_TARGET
		held_card_sprite.texture = held_card.mouse_empty
		_tilemap_master.hide_buildable_tiles()

func connect_signals():
	for card_button in %Cards.get_children():
		card_button = card_button as CardButton
		if card_button and not card_button.card_pressed.is_connected(hold_card):
			card_button.card_pressed.connect(hold_card)

func hold_card(card: Card):
	if held_card:
		release_card()
	held_card = card
	held_card.active = true
	held_card.context_changed.connect(_on_card_context_changed)
	Events.start_card_activation.emit(held_card)
	held_card_sprite = Sprite2D.new()
	held_card_sprite.scale = Vector2(0.35, 0.35)
	get_tree().root.add_child(held_card_sprite)
	update_ctx()

func release_card():
	held_card.context_changed.disconnect(_on_card_context_changed)
	held_card = null
	held_card_sprite.queue_free()
	held_card_sprite = null
	_tilemap_master.hide_buildable_tiles()
	update_ctx()

func _on_expand_mouse_entered():
	cardsPanel.show()
	expand.hide()


func _on_close_mouse_entered():
	cardsPanel.hide()
	expand.show()

func _on_card_context_changed(old_context, new_context):
	print("Old context: ", old_context, " new card: ", new_context)
