extends CanvasLayer

@onready var cardsPanel = $CardsPanel
@onready var expand = $Expand


func _ready():
	show()
	cardsPanel.hide()
	expand.show()

func _on_expand_mouse_entered():
	cardsPanel.show()
	expand.hide()


func _on_close_mouse_entered():
	cardsPanel.hide()
	expand.show()
