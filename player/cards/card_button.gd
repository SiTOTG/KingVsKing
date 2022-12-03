@tool
extends TextureButton

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
