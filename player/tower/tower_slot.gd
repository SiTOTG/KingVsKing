extends Area2D

var card: Card

var preview: Node2D
var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.start_card_activation_event.connect(_show_tower)
	Events.finish_card_activation_event.connect(_hide_tower)

func _show_tower(card: Card):
	print("Show card")
	self.card = card
	if hovering:
		card.hovering_tower_slot = self
		preview = card.mouse_tower_preview.instantiate()
		preview.name = "Preview"
		add_child(preview)
		var animation: Animation = $AnimationPlayer.get_animation("show_preview")
		animation.track_set_path(0, "Preview:modulate")
		$AnimationPlayer.play("show_preview")

func _hide_tower():
	#if card.hovering_tower_slot == self:
	#	card.hovering_tower_slot = null
	#self.card = null
	if preview != null:
		preview.queue_free()
		$AnimationPlayer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$CollisionShape2D.polygon = $Polygon2D.polygon
	pass

func _on_mouse_entered():
	if card:
		card.hovering_tower_slot = self
	hovering = true
	_show_tower(card)

func _on_mouse_exited():
	#if card and card.hovering_tower_slot == self:
	#	card.hovering_tower_slot = null
	hovering = false
	_hide_tower()
