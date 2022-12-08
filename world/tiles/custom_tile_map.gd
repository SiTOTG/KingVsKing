class_name CustomTileMap
extends TileMap

func get_buildable_cells(origin: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var buildable_cells = []
	var available_cells := get_available_cells(origin, size)
	for cell in available_cells:
		var cell_data: TileData = get_cell_tile_data(0, cell)
		if cell_data.get_custom_data("Buildable") == true:
			buildable_cells.append(cell)
	return buildable_cells

func get_available_cells(origin: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var used_cells = get_used_cells(0)
	var available_cells = []
	for i in range(origin.x-size.x, origin.x+size.x+1):
		for j in range(origin.y-size.y, origin.y+size.y+1):
			var cell = Vector2i(i, j)
			if cell in used_cells:
				available_cells.append(cell)
	return available_cells
