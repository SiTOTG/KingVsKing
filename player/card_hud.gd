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
	NO_TARGET,
	SPAWNER
}

var ctx: int = NO_TARGET

func _ready():
	show()
	cardsPanel.hide()
	expand.show()
	_tilemap_master = get_node(tilemap_master)

	connect_signals()

func _unhandled_input(event):
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		event = event as InputEventMouseButton
		if held_card and ctx == SPAWNER and _tilemap_master.can_build_there():
			var spawner = load(held_card.spawner_scene) as PackedScene
			create_spawner.emit(_tilemap_master.get_origin_position(), spawner)

func _physics_process(delta):
	if held_card_sprite:
		held_card_sprite.global_position = held_card_sprite.get_global_mouse_position()
		update_ctx()

func update_ctx():
	if _tilemap_master.is_over_tile():
		if ctx != SPAWNER:
			ctx = SPAWNER
			held_card_sprite.texture = held_card.mouse_build
			held_card_sprite.scale = Vector2(0.232, 0.232)
			held_card_sprite.self_modulate.a = 0.4
			_tilemap_master.show_buildable_tiles(Vector2i(3, 2))
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
	held_card_sprite = Sprite2D.new()
	held_card_sprite.scale = Vector2(0.35, 0.35)
	get_tree().root.add_child(held_card_sprite)
	update_ctx()
	print("Holding card ", card.title)

func release_card():
	held_card = null
	held_card_sprite.queue_free()

func _on_expand_mouse_entered():
	cardsPanel.show()
	expand.hide()


func _on_close_mouse_entered():
	cardsPanel.hide()
	expand.show()
