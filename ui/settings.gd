extends Control

var settings_file = "user://settings.json"

var full_load = true

var settings: Dictionary = {}

const default_settings = {
	"bgm_volume": 0,
	"master_volume": -15,
	"mute_bgm": false,
	"mute_master": false,
	"mute_sfx": false,
	"sfx_volume": 0
}

@onready var volume_value = %VolumeValue
@onready var sfx_volume_value = %SFXVolumeValue
@onready var mute_master = %MuteMaster
@onready var mute_sfx = %MuteSFX
@onready var bgm_volume_value = %BGMVolumeValue
@onready var mute_bgm = %MuteBGM

const MIN_VOLUME_MASTER = -40
const MAX_VOLUME_MASTER = 10

const MIN_VOLUME_SFX = -30
const MAX_VOLUME_SFX = 0

const MIN_VOLUME_BGM = -30
const MAX_VOLUME_BGM = 0

enum {
	BUS_SFX
}

func _ready():
	volume_value.min_value = MIN_VOLUME_MASTER
	volume_value.max_value = MAX_VOLUME_MASTER
	sfx_volume_value.min_value = MIN_VOLUME_SFX
	sfx_volume_value.max_value = MAX_VOLUME_SFX
	bgm_volume_value.min_value = MIN_VOLUME_BGM
	bgm_volume_value.max_value = MAX_VOLUME_BGM
	full_load = true
	load_settings()

func load_settings():
	if not FileAccess.file_exists(settings_file):
		print("Settings file not found, creating...")
		var file: FileAccess = FileAccess.open(settings_file, FileAccess.WRITE)
		file.store_string(JSON.stringify(default_settings, "\t"))
		settings = default_settings.duplicate(true)
	else:
		var file: FileAccess = FileAccess.open(settings_file, FileAccess.READ)
		settings = JSON.parse_string(file.get_as_text())

	reset_ui()

	Events.settings_changed_event.emit({}, settings)
	full_load = false

func reset_ui():
	volume_value.value = settings.master_volume
	mute_master.button_pressed = settings.mute_master
	sfx_volume_value.value = settings.sfx_volume
	mute_sfx.button_pressed = settings.mute_sfx
	bgm_volume_value.value = settings.bgm_volume
	mute_bgm.button_pressed = settings.mute_bgm

func _on_apply_button_pressed():
	var old_settings = settings.duplicate(true)
	settings.master_volume = volume_value.value
	settings.mute_master = mute_master.button_pressed
	settings.sfx_volume = sfx_volume_value.value
	settings.mute_sfx = mute_sfx.button_pressed
	settings.bgm_volume = bgm_volume_value.value
	settings.mute_bgm = mute_bgm.button_pressed
	var file = FileAccess.open(settings_file, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))
	Events.settings_changed_event.emit(old_settings, settings)

func _on_reset_button_pressed():
	load_settings()

func _on_volume_value_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_sfx_volume_value_value_changed(value):
	if not full_load and not $TestSFX.playing:
		$TestSFX.playing = true
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func _on_bgm_volume_value_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), value)

func _on_mute_master_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)

func _on_mute_sfx_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), button_pressed)

func _on_mute_bgm_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), button_pressed)


func _on_close_button_pressed():
	full_load = true
	visible = false
	load_settings()


func _on_button_pressed():
	settings = default_settings.duplicate(true)
	full_load = true
	reset_ui()


func _on_visibility_changed():
	if get_tree():
		get_tree().paused = visible
