class_name Card
extends Resource

@export_group("Hud icons")
@export var hud_normal: Texture2D
@export var hud_select: Texture2D
@export_group("Mouse follow icons")
@export var mouse_build: Texture2D
@export var mouse_empty: Texture2D
@export var mouse_cast: Texture2D
@export var mouse_upgrade: Texture2D
@export_group("Stats")
@export var title: String = ""

@export_group("Effect")
@export_file("*.tscn") var spawner_scene
@export var spawner_size: Vector2i = Vector2i.ONE

# Context variables, relevant when active
enum {
	RESET,
	NO_TARGET,
	SPAWNER
}

signal context_changed(old_context: int, new_context: int)

var active = false:
	set(value):
		active = value
		update_ctx()
var hovering_tiles = false:
	set(value):
		hovering_tiles = value
		update_ctx()

var ctx: int = RESET

func update_ctx():
	var new_ctx
	if active:
		if hovering_tiles:
			new_ctx = SPAWNER
		else:
			new_ctx = NO_TARGET
	else: new_ctx = RESET
	if ctx != new_ctx:
		context_changed.emit(ctx, new_ctx)
		ctx = new_ctx
