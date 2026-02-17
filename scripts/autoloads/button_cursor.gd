extends Node

func _ready():
	set_cursor_for_buttons(get_tree().get_root())
	get_tree().connect("node_added", Callable(self, "_on_node_added"))

func set_cursor_for_buttons(node):
	if node is Button:
		node.mouse_filter = Control.MOUSE_FILTER_STOP
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for child in node.get_children():
		set_cursor_for_buttons(child)

func _on_node_added(node):
	if node is Button:
		node.mouse_filter = Control.MOUSE_FILTER_STOP
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
