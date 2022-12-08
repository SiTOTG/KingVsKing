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
