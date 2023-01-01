extends CanvasLayer

const CardButtonScene = preload("res://player/cards/card_button.tscn")

@export_node_path("TileMap") var tilemap_master
@export var card_manager: CardManager

@onready var cardsPanel = $CardsPanel
@onready var expand = $Expand
@onready var cards = %Cards
@onready var card_progress = $CardProgress

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
	
	if ReferenceStash.card_manager:
		card_manager = ReferenceStash.card_manager
	elif card_manager == null:
		card_manager = CardManager.new()

	ReferenceStash.card_manager = card_manager
	card_manager.clear_hand()

	connect_signals()

func connect_signals():
	for card_button in %Cards.get_children():
		card_button = card_button as CardButton
		if card_button and not card_button.card_pressed.is_connected(hold_card):
			card_button.card_pressed.connect(hold_card)
	if not card_manager.hand_updated.is_connected(_on_hand_updated):
		card_manager.hand_updated.connect(_on_hand_updated)

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


func _on_card_progress_charge_rate_timeout():
	if card_progress.value < card_progress.max_value: card_progress.value += 1
	if card_progress.value >= card_progress.max_value:
		if card_manager.pick_card() == card_manager.ErrorCode.SUCCESS:
			card_progress.value = card_progress.min_value

func _on_hand_updated():
	for card_button in cards.get_children():
		cards.remove_child(card_button)
		card_button.queue_free()
	for card in card_manager.hand:
		card = card as Card
		var card_button = CardButtonScene.instantiate()
		card_button.card = card
		cards.add_child(card_button)
	connect_signals()
