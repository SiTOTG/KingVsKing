extends CanvasLayer

@onready var cards = $CardsPanel
@onready var expand = $Expand


func _ready():
	cards.hide()
	expand.show()

func _on_expand_mouse_entered():
	cards.show()
	expand.hide()


func _on_close_mouse_entered():
	cards.hide()
	expand.show()
