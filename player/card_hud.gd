extends CanvasLayer

@onready var cardsPanel = $CardsPanel
@onready var expand = $Expand
@onready var cards = %Cards
@onready var held_card = $HeldCard


func _ready():
	show()
	cardsPanel.hide()
	expand.show()

	connect_signals()

func _physics_process(delta):
	held_card.global_position = held_card.get_global_mouse_position()

func connect_signals():
	for card_button in %Cards.get_children():
		card_button = card_button as CardButton
		if card_button and not card_button.card_pressed.is_connected(hold_card):
			card_button.card_pressed.connect(hold_card)

func hold_card(card: Card):
	held_card.texture = card.mouse_empty
	print("Holding card ", card.title)

func _on_expand_mouse_entered():
	cardsPanel.show()
	expand.hide()


func _on_close_mouse_entered():
	cardsPanel.hide()
	expand.show()
