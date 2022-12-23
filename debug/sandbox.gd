extends Node2D
#
#@onready var footman: Creature = $Footman
#@onready var origin = footman.global_position
#
#var destination_lane_1
#
#func _ready():
#	destination_lane_1 = $DestinationLane1
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if footman.global_position.distance_to(destination_lane_1.global_position) < 15:
#		footman.destination = origin
#		footman.agent.target_location = footman.destination
#	elif footman.global_position.distance_to(origin) < 15:
#		footman.destination = destination_lane_1.global_position
#		footman.agent.target_location = footman.destination


@onready var spawner = $BuildingRegion
@onready var collision_shape_2d = $BuildingRegion/CollisionShape2D
@onready var navigation_region_2d = $NavigationRegion2D

func _ready():
	print(spawner.get_polygon())

#				var polygon = spawner.get_polygon()
#				var navpoly: NavigationPolygon = navigation_region_2d.navpoly
#				var new_cut_out_poly : PackedVector2Array = PackedVector2Array()
#
#				for vertex in polygon:
#					var current_vertex : Vector2 = vertex
#					new_cut_out_poly.append(spawner.global_transform.basis_xform(current_vertex))
#				print(navpoly.get_outline(0))
#				print(Geometry2D.exclude_polygons(navpoly.get_outline(0), polygon))
#				navpoly.add_outline(new_cut_out_poly)
##				navpoly.set_outline(0, new_cut_out_poly)
##				navpoly.set_outline(0, Geometry2D.exclude_polygons(navpoly.get_outline(0), polygon))
#				navpoly.make_polygons_from_outlines()

func _process(delta):
	spawner.global_position = get_global_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var polygon = spawner.get_polygon()
		var navpoly: NavigationPolygon = navigation_region_2d.navpoly
		var new_cut_out_poly : PackedVector2Array = PackedVector2Array()
		for vertex in polygon:
			var current_vertex : Vector2 = vertex
			new_cut_out_poly.append(spawner.global_transform.basis_xform(current_vertex))
		print(new_cut_out_poly)
		print(Geometry2D.exclude_polygons(navpoly.get_outline(0), new_cut_out_poly))
		navpoly.add_outline(Geometry2D.exclude_polygons(navpoly.get_outline(0), polygon))
#		print(navpoly.outlines)
		navpoly.make_polygons_from_outlines()
		navigation_region_2d.force_update_transform()
