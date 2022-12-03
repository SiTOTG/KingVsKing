extends Camera2D

const VELOCITY_MOVE_KEYBOARD = 300

@export_range(1.5, 4) var ZOOM_IN_LIMIT = 3
@export_range(0.1, 0.5) var ZOOM_OUT_LIMIT = 0.3
@export_range(0.03, 0.15) var ZOOM_SLOW_SPEED = 0.1

var mouse_start_pos
var screen_start_position

var dragging = false
#
#func _ready():
#	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _unhandled_input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event.is_action("zoom_in_slow"):
		zoom.x = min(zoom.x + ZOOM_SLOW_SPEED, ZOOM_IN_LIMIT)
		zoom.y = zoom.x
	elif event.is_action("zoom_out_slow"):
		zoom.x = max(zoom.x - ZOOM_SLOW_SPEED, ZOOM_OUT_LIMIT)
		zoom.y = zoom.x
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) + screen_start_position

func _process(delta):
	var move_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if move_input != Vector2.ZERO:
		position = move_input*delta*VELOCITY_MOVE_KEYBOARD + position
