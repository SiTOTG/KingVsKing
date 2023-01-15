extends Area2D

var card: Card

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.start_card_activation_event.connect(_show_tower)
	Events.finish_card_activation_event.connect(_hide_tower)

func _show_tower(card: Card):
	print("Show card")
	self.card = card
	
	$VisibleTower.texture = card.mouse_tower
	$VisibleTower.show()

func _hide_tower():
	self.card = null
	$VisibleTower.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
