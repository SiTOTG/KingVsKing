extends TileMap

const BUILDABLE_ATLAS_COORDS = Vector2i(0, 0)
const BLOCKED_ATLAS_COORDS = Vector2i(0, 1)

@export_node_path(CanvasLayer) var card_hud
var _card_hud

func _ready():
	_card_hud = get_node_or_null(card_hud)

var hovering_cell: Vector2i

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var cell_position = local_to_map(get_local_mouse_position())

		if _card_hud.held_card:
			print(_card_hud.held_card.title)
			print("holding card")
	elif event is InputEventMouseMotion and _card_hud.held_card:
		var cell_position = local_to_map(get_local_mouse_position())
		if cell_position == hovering_cell:
			return

		hovering_cell = cell_position
		
		var size = Vector2i(1, 2)
		
		var buildable_cells = get_buildable_cells(hovering_cell, size)
		
#		for cell in get_used_cells(0):
#			set_cell(0, cell, -1)
#
		clear()
		color_cells(buildable_cells, hovering_cell, size)

func color_cells(buildable_cells: Array[Vector2i], origin: Vector2i, size: Vector2i):
	for i in range(origin.x-size.x, origin.x+size.x+1):
		for j in range(origin.y-size.y, origin.y+size.y+1):
			var cell = Vector2i(i, j)
			if cell in buildable_cells:
				set_cell(0, cell, 0, BUILDABLE_ATLAS_COORDS)
			else:
				set_cell(0, cell, 0, BLOCKED_ATLAS_COORDS)

func get_buildable_cells(origin: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var buildable_cells = []
	for custom_tile_map in get_children():
		custom_tile_map = custom_tile_map as CustomTileMap
		if not custom_tile_map:
			continue
		var buildable_cells_child = custom_tile_map.get_buildable_cells(origin, size)
		for cell in buildable_cells_child:
			if not buildable_cells.has(cell):
				buildable_cells.append(cell)
	return buildable_cells
