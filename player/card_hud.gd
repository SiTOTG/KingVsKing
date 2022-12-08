extends CanvasLayer

@export_node_path("TileMap") var tilemap_master

@onready var cardsPanel = $CardsPanel
@onready var expand = $Expand
@onready var cards = %Cards
@onready var held_card_sprite = $HeldCard


var held_card: Card = null
var _tilemap_master: TilemapMaster

func _ready():
	show()
	cardsPanel.hide()
	expand.show()
	_tilemap_master = get_node(tilemap_master)

	connect_signals()

func _physics_process(delta):
	held_card_sprite.global_position = held_card_sprite.get_global_mouse_position()

func connect_signals():
	for card_button in %Cards.get_children():
		card_button = card_button as CardButton
		if card_button and not card_button.card_pressed.is_connected(hold_card):
			card_button.card_pressed.connect(hold_card)

func hold_card(card: Card):
	held_card_sprite.texture = card.mouse_empty
	_tilemap_master.show_buildable_tiles(Vector2i(2, 3))
	held_card = card
	print("Holding card ", card.title)

func _on_expand_mouse_entered():
	cardsPanel.show()
	expand.hide()


func _on_close_mouse_entered():
	cardsPanel.hide()
	expand.show()
