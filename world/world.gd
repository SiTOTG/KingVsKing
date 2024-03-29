class_name World
extends Node2D

@onready var destination_lane_1 = $DestinationLane1
@onready var tilemap_master: TilemapMaster = $TilemapMaster
@onready var settings = %Settings
@onready var settings_button = %SettingsButton

var active_card: Card


func _unhandled_input(event):
	if event.is_action_pressed("toggle_creature_ui"):
		GlobalSettings.show_creature_ui = not GlobalSettings.show_creature_ui

func _ready():
	Events.start_card_activation_event.connect(func(card: Card): active_card = card)
	Events.confirm_card_activation_event.connect(_on_card_confirm_activation)
	settings.visibility_changed.connect(_on_settings_visibility_changed)

func _on_card_confirm_activation():
	if active_card.ctx == Card.SPAWNER and tilemap_master.can_build_there():
		tilemap_master.set_tiles_as_blocked()
		var spawner_position: Vector2 = tilemap_master.get_origin_position() + tilemap_master.HALF_TILE_SIZE
		var spawner_scene: PackedScene = load(active_card.spawner_scene)
		var spawner = spawner_scene.instantiate() as Spawner
		spawner.add_to_group("Ally")
		spawner.global_position = spawner_position
		spawner.starting_move_position = destination_lane_1.global_position
		add_child(spawner)
		_consume_card()

func _consume_card():
	if is_instance_valid(active_card):
		active_card.active = false
		active_card.use()

func _on_castle_destroyed():
	$GameOverUI.visible = true
	var match_stats = MatchStats.new()
	match_stats.victory = false
	$GameOverUI.match_stats = match_stats
	get_tree().paused = true


func _on_demon_commander_destroyed():
	$GameOverUI.visible = true
	var match_stats = MatchStats.new()
	match_stats.victory = true
	$GameOverUI.match_stats = match_stats
	get_tree().paused = true

func _on_settings_button_pressed():
	settings.visible = true

func _on_settings_visibility_changed():
	settings_button.visible = not settings.visible


func _on_tower_slot_tower_created():
	_consume_card()

func _on_path_slot_pathbuild_created():
	_consume_card()
