class_name CardManager
extends Resource

@export var hand: Array[Card] = []
@export var deck: Array[Card] = []

@export var max_hand_size: int = 5

signal hand_updated

class ErrorCode:
	const EMPTY_DECK = "Empty Deck"
	const HAND_FULL = "Hand Full"
	const SUCCESS = "Success"

func _init():
	if hand == null:
		hand = []
	if deck == null:
		deck = []

func pick_card() -> String:
	if deck.is_empty():
		return ErrorCode.EMPTY_DECK
	if len(hand) >= max_hand_size:
		return ErrorCode.HAND_FULL
	var current: Card = deck.pop_front().duplicate()
	hand.append(current)
	current.used.connect(_on_card_used.bind(current))
	deck.push_back(current)
	hand_updated.emit()
	return ErrorCode.SUCCESS

func _on_card_used(card):
	hand.erase(card)
	hand_updated.emit()

func clear_hand():
	hand.clear()
