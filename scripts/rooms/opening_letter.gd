extends Node

signal read_letter

func _on_button_pressed() -> void:
	emit_signal("read_letter")

func _on_exit() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
