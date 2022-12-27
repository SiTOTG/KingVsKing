class_name World
extends Node2D

@onready var destination_lane_1 = $DestinationLane1
@onready var tilemap_master: TilemapMaster = $TilemapMaster
@onready var navigation_region_2d = $NavigationRegion2D

var active_card: Card


func _unhandled_input(event):
	if event.is_action_pressed("toggle_creature_ui"):
		GlobalSettings.show_creature_ui = not GlobalSettings.show_creature_ui

func _ready():
	Events.start_card_activation_event.connect(func(card: Card): active_card = card)
	Events.confirm_card_activation_event.connect(_on_card_confirm_activation)
	var navpoly: NavigationPolygon = navigation_region_2d.navpoly
	navpoly.get_mesh().agent_radius = 32
	

func _process(delta):
	var building_units: Array[Node] = get_tree().get_nodes_in_group("Building")

func _on_card_confirm_activation():
	if active_card.ctx == Card.SPAWNER and tilemap_master.can_build_there():
		tilemap_master.set_tiles_as_blocked()
		var position: Vector2 = tilemap_master.get_origin_position() + tilemap_master.HALF_TILE_SIZE
		var spawner_scene: PackedScene = load(active_card.spawner_scene)
		var spawner = spawner_scene.instantiate() as Spawner
		spawner.add_to_group("Ally")
		spawner.global_position = position
		spawner.starting_move_position = destination_lane_1.global_position
		# Provisional code, might be necessary for future navigation changes
#		spawner.ready.connect(
#			func():
#				var polygon = spawner.get_polygon()
#				var navpoly: NavigationPolygon = navigation_region_2d.navpoly
#				var new_cut_out_poly : PackedVector2Array = PackedVector2Array()
#				print(polygon)
#				for vertex in polygon:
#					var current_vertex : Vector2 = vertex
#					new_cut_out_poly.append(spawner.global_transform.basis_xform(current_vertex))
#				print(navpoly.get_outline(0))
#				print(Geometry2D.exclude_polygons(navpoly.get_outline(0), polygon))
#				navpoly.add_outline(new_cut_out_poly)
#				navpoly.make_polygons_from_outlines()
#		)
		add_child(spawner)
		active_card.active = false


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
