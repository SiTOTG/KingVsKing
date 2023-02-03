class_name CustomTileMap
extends TileMapBase

func get_buildable_cells(origin: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var buildable_cells: Array[Vector2i] = []
	var available_cells := get_available_cells(origin, size)
	for cell in available_cells:
		var cell_data: TileData = get_cell_tile_data(0, cell)
		if cell_data.get_custom_data("Buildable") == true:
			buildable_cells.append(cell)
	return buildable_cells

func get_available_cells(origin: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var used_cells = get_used_cells(0)
	var available_cells: Array[Vector2i] = []
	for cell in get_tiles_in_area(origin, size):
		if cell in used_cells:
			available_cells.append(cell)
	return available_cells
