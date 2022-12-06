@tool
class_name CardButton
extends TextureButton

signal card_pressed(card: Card)

@export var card: Card:
	set(value):
		card = value
		if value:
			texture_normal = card.hud_normal
			texture_pressed = card.hud_select
			texture_hover = card.hud_select
			texture_disabled = card.hud_select
		else:
			texture_normal = null
			texture_pressed = null
			texture_hover = null
			texture_disabled = null


func _on_pressed():
	card_pressed.emit(card)
