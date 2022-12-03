extends CanvasLayer

@onready var cards = $HBoxContainer
@onready var expand = $CanvasLayer/Expand
@onready var canvas = $CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	cards.hide()
	expand.show()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_expand_mouse_entered():
	pass
	

	
func _on_h_box_container_mouse_exited():
	pass


func _on_expandable_mouse_entered():
	cards.show()
	expand.hide()


func _on_close_mouse_entered():
	cards.hide()
	expand.show()
