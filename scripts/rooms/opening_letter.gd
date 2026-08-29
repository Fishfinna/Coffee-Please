extends Node

signal read_letter

func _on_button_pressed() -> void:
	emit_signal("read_letter")
