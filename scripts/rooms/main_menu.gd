extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_exit_button_down() -> void:
	get_tree().quit()

func _on_contine_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_settings_button_down() -> void:
	var scene = load("res://scenes/MyScene.tscn")
	var instance = scene.instantiate()
	get_tree().root.add_child(instance)
