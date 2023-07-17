extends Control

var world_scene_path = "res://world/world.tscn"

func _ready():
	var error = ResourceLoader.load_threaded_request(world_scene_path, "", false, ResourceLoader.CACHE_MODE_IGNORE)
	if error != OK:
		print("Error when trying to load the scene")
		return
	%LoadingLabel.text = "Loading..."
	$LoadingTimer.start()

func _on_start_button_pressed():
	var world_scene = ResourceLoader.load_threaded_get(world_scene_path)
	get_tree().change_scene_to_packed(world_scene)

func _on_settings_button_pressed():
	$Settings.visible = true

func _on_loading_timer_timeout():
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(world_scene_path, progress)
	%LoadingProgressBar.value = int(progress[0]*100)
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		print("Loading... ", progress[0])
	elif ResourceLoader.THREAD_LOAD_LOADED:
		print("Finished loading")
		%LoadingLabel.text = "Finished Loading!"
		$LoadingTimer.stop()
	else:
		printerr("Loading failed with time")
