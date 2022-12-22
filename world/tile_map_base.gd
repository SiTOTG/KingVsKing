class_name TileMapBase
extends TileMap

func get_tiles_in_area(origin: Vector2i, size: Vector2i):
	var cells = []
	for i in range(origin.x-size.x+1, origin.x+size.x+1):
		for j in range(origin.y-size.y+1, origin.y+size.y+1):
			var cell = Vector2i(i, j)
			cells.append(cell)
	return cells
