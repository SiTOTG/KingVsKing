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
@export var spawner_size: Vector2i

var _used = false

# Context variables, relevant when active
enum {
	RESET,
	NO_TARGET,
	SPAWNER
}

signal context_changed(old_context: int, new_context: int)
signal used

func calculate_spawner_size():
	if spawner_scene == null: return
	var pack: PackedScene = load(spawner_scene)
	var temp_node: Spawner = pack.instantiate()
	var collider: CollisionShape2D = temp_node.get_node("CollisionShape2D")
	var collider_shape: RectangleShape2D = collider.shape as RectangleShape2D
	var collider_rect: Rect2 = collider_shape.get_rect()
	spawner_size = Vector2i(collider_rect.size/32)
	temp_node.free()

var active: bool = false:
	set(value):
		if active != value:
			active = value
			if active:
				Events.start_card_activation_event.emit(self)
			else:
				Events.finish_card_activation_event.emit()
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
			calculate_spawner_size()
			new_ctx = SPAWNER
		else:
			new_ctx = NO_TARGET
	else: new_ctx = RESET
	if ctx != new_ctx:
		context_changed.emit(ctx, new_ctx)
		ctx = new_ctx

func use():
	_used = true
	used.emit()
