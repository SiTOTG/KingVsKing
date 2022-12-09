extends Node2D

@onready var destination_lane_1 = $DestinationLane1
@onready var tilemap_master: TilemapMaster = $TilemapMaster

var active_card: Card

func _unhandled_input(event):
	if event.is_action_pressed("toggle_creature_ui"):
		GlobalSettings.show_creature_ui = not GlobalSettings.show_creature_ui

func _ready():
	Events.start_card_activation.connect(func(card: Card): active_card = card)
	Events.confirm_card_activation.connect(_on_card_confirm_activation)

func _on_card_confirm_activation():
	if active_card.ctx == Card.SPAWNER and tilemap_master.can_build_there():
		tilemap_master.set_tiles_as_blocked()
		var position: Vector2 = tilemap_master.get_origin_position()
		var spawner_scene: PackedScene = load(active_card.spawner_scene)
		var spawner = spawner_scene.instantiate() as Spawner
		spawner.global_position = position
		spawner.starting_move_position = destination_lane_1.global_position
		add_child(spawner)
		active_card.active = false
