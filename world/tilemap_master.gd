class_name TilemapMaster
extends TileMap

const BUILDABLE_ATLAS_COORDS = Vector2i(0, 0)
const BLOCKED_ATLAS_COORDS = Vector2i(0, 1)

var is_showing_buidable_tiles: bool = false
var origin: Vector2i = Vector2i.ZERO
var size: Vector2i = Vector2i.ONE

func _unhandled_input(event):
	if event is InputEventMouseMotion and is_showing_buidable_tiles:
		var cell_position = local_to_map(get_local_mouse_position())
		if cell_position == origin:
			return

		origin = cell_position

		var size = Vector2i(1, 2)

		var buildable_cells = get_buildable_cells()

		clear()
		color_cells(buildable_cells)

func show_buildable_tiles(size: Vector2i):
	self.origin = local_to_map(get_local_mouse_position())
	self.size = size
	is_showing_buidable_tiles = true
	

func is_over_tile() -> bool:
	var cell_position: Vector2i = local_to_map(get_local_mouse_position())
	for custom_tile_map in get_children():
		custom_tile_map = custom_tile_map as CustomTileMap
		if not custom_tile_map: continue
		if cell_position in custom_tile_map.get_used_cells(0): return true
	return false

func color_cells(buildable_cells: Array[Vector2i]):
	for i in range(origin.x-size.x, origin.x+size.x+1):
		for j in range(origin.y-size.y, origin.y+size.y+1):
			var cell = Vector2i(i, j)
			if cell in buildable_cells:
				set_cell(0, cell, 0, BUILDABLE_ATLAS_COORDS)
			else:
				set_cell(0, cell, 0, BLOCKED_ATLAS_COORDS)

func get_buildable_cells() -> Array[Vector2i]:
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
