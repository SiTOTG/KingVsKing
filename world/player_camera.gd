extends Camera2D

const VELOCITY_MOVE_KEYBOARD = 300

var mouse_start_pos
var screen_start_position

var dragging = false


func _unhandled_input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
	

func _process(delta):
	var move_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if move_input != Vector2.ZERO:
		position = zoom * move_input*delta*VELOCITY_MOVE_KEYBOARD + position
