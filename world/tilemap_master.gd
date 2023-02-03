class_name TilemapMaster
extends TileMapBase

const BUILDABLE_ATLAS_COORDS = Vector2i(0, 0)
const BLOCKED_ATLAS_COORDS = Vector2i(0, 1)
const HALF_TILE_SIZE = Vector2(8, 8)

var is_showing_buidable_tiles: bool = false
var origin: Vector2i = Vector2i.ZERO
var size: Vector2i = Vector2i.ONE
var rect: Rect2i = Rect2i(1, 1, 1, 1)

var occupied_cells: Array[Vector2i] = []

var active_card: Card:
	set(value):
		active_card = value

func _ready():
	Events.start_card_activation_event.connect(_on_card_activate)
	Events.finish_card_activation_event.connect(_on_card_deactivate)

func _unhandled_input(event):
	if event is InputEventMouseMotion and active_card:
		var cell_position = local_to_map(get_local_mouse_position())
		if cell_position != origin:
			active_card.hovering_tiles = is_over_tile()

	if event is InputEventMouseMotion and is_showing_buidable_tiles:
		var cell_position = local_to_map(get_local_mouse_position())
		if cell_position == origin:
			return

		origin = cell_position
		Events.hover_tile_event.emit(to_global(map_to_local(origin)) + HALF_TILE_SIZE)

		var buildable_cells = get_buildable_cells()

		clear()
		color_cells(buildable_cells)

func get_origin_position() -> Vector2:
	return map_to_local(origin)

func set_tiles_as_blocked():
	var buildable_tiles = get_buildable_cells()
	occupied_cells.append_array(buildable_tiles)

func show_buildable_tiles(new_size: Vector2i):
	self.origin = local_to_map(get_local_mouse_position())
	self.size = new_size
	is_showing_buidable_tiles = true

func hide_buildable_tiles():
	is_showing_buidable_tiles = false
	clear()

func can_build_there() -> bool:
	var buildable_cells = get_buildable_cells()
	for cell in get_tiles_in_area(origin, size):
		if not cell in buildable_cells:
			return false
	return true

func is_over_tile() -> bool:
	var cell_position: Vector2i = local_to_map(get_local_mouse_position())
	for custom_tile_map in get_children():
		custom_tile_map = custom_tile_map as CustomTileMap
		if not custom_tile_map: continue
		if cell_position in custom_tile_map.get_used_cells(0): return true
	return false

func color_cells(buildable_cells: Array[Vector2i]):
	for cell in get_tiles_in_area(origin, size):
		if cell in buildable_cells:
			set_cell(0, cell, 0, BUILDABLE_ATLAS_COORDS)
		else:
			set_cell(0, cell, 0, BLOCKED_ATLAS_COORDS)

func get_buildable_cells() -> Array[Vector2i]:
	var buildable_cells: Array[Vector2i] = []
	for custom_tile_map in get_children():
		custom_tile_map = custom_tile_map as CustomTileMap
		if not custom_tile_map:
			continue
		var buildable_cells_child = custom_tile_map.get_buildable_cells(origin, size)
		for cell in buildable_cells_child:
			if not buildable_cells.has(cell) and not occupied_cells.has(cell):
				buildable_cells.append(cell)
	return buildable_cells

func _on_card_activate(card: Card):
	active_card = card
	active_card.context_changed.connect(_on_card_context_changed)

func _on_card_deactivate():
	active_card.context_changed.disconnect(_on_card_context_changed)
	active_card = null
	hide_buildable_tiles()

func _on_card_context_changed(_old_context: int, new_context: int):
	if new_context == Card.SPAWNER:
		show_buildable_tiles(active_card.spawner_size)
	else:
		hide_buildable_tiles()
