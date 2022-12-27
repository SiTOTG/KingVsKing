extends CanvasLayer

var match_stats: MatchStats = MatchStats.new():
	set(value):
		match_stats = value
		setup()

func setup():
	if match_stats.victory:
		%MatchGameoverTitle.text = "Victory!"
	else: %MatchGameoverTitle.text = "Defeat!"


func _on_start_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
