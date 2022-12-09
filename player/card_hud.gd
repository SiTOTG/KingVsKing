extends CanvasLayer

@export_node_path("TileMap") var tilemap_master

@onready var cardsPanel = $CardsPanel
@onready var expand = $Expand
@onready var cards = %Cards


var active_card: Card = null

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

	connect_signals()

func connect_signals():
	for card_button in %Cards.get_children():
		card_button = card_button as CardButton
		if card_button and not card_button.card_pressed.is_connected(hold_card):
			card_button.card_pressed.connect(hold_card)

func hold_card(card: Card):
	if active_card:
		release_card()
	active_card = card
	active_card.active = true

func release_card():
	active_card.active = false
	active_card = null

func _on_expand_mouse_entered():
	cardsPanel.show()
	expand.hide()


func _on_close_mouse_entered():
	cardsPanel.hide()
	expand.show()
