extends Node

signal start_card_activation_event(card: Card)
signal finish_card_activation_event()
signal cancel_card_activation_event()
signal confirm_card_activation_event()
signal settings_changed_event(old_settings: Dictionary, new_settings: Dictionary)

signal hover_tile_event(center_position: Vector2)

func _ready():
	if ProjectSettings.get("debug/settings/events/log_events"):
		var signals = get_signal_list()
		for s in signals:
			if s.name.ends_with("_event"):
				self.connect(s.name, log_event.bind(s))

# Log up to 5 arguments
func log_event(event, a1="no_arg", a2="no_arg", a3="no_arg", a4="no_arg", a5="no_arg"):
	print_debug(event)
	var args = [a1, a2, a3, a4, a5]
	for arg in args:
		if not arg is String or arg != "no_arg":
			print_debug("Argument: ", arg)
