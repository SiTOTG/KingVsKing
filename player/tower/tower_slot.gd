extends Area2D

var card: Card
var tower
var world: World

var preview: Node2D
var hovering = false

signal tower_created

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.start_card_activation_event.connect(_show_tower)
	Events.finish_card_activation_event.connect(_hide_tower)
	world =  self.get_parent()
	tower_created.connect(world._on_tower_created)

func _show_tower(card: Card):
	if not is_instance_valid(card):
		return
	self.card = card
	if hovering:
		card.hovering_tower_slot = self
		preview = card.mouse_tower_preview.instantiate()
		preview.name = "Preview"
		add_child(preview)
		var animation: Animation = $AnimationPlayer.get_animation("show_preview")
		animation.track_set_path(0, "Preview:modulate")
		$AnimationPlayer.play("show_preview")
		
func _build_tower(card: Card):
	if is_instance_valid(card):
		if "tower_scene" in card:
			if not is_instance_valid(tower):
				tower = load(card.tower_scene)
				var t = tower.instantiate()
				self.add_child(t)
				#print(t.projectile_origin.transform)
				#t.projectile_origin.transform.x = Vector2(0,0)
				#t.projectile_origin.transform.y = Vector2(0,0)
				emit_signal("tower_created")
		

func _hide_tower():
	if is_instance_valid(preview):
		preview.queue_free()
		$AnimationPlayer.stop()

func _on_mouse_entered():
	if card:
		card.hovering_tower_slot = self
	hovering = true
	_show_tower(card)

func _on_mouse_exited():
	if is_instance_valid(card):
		card.hovering_tower_slot = null
	hovering = false
	_hide_tower()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if hovering == true:
				_build_tower(card)

