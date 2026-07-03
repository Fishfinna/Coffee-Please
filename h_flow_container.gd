extends VFlowContainer

@export var max_width: float = 300.0

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		if size.x > max_width:
			custom_minimum_size.x = max_width
		else:
			custom_minimum_size.x = 0
