extends Node2D

@onready var contine: Button = $Panel/Control/HBoxContainer/contine
var save_manager = SaveManager.new()

func _ready() -> void:
	contine.visible = false
	if len(save_manager.list_saves()):
		contine.visible = true
	
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_exit() -> void:
	get_tree().quit()

func _on_contine() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_settings() -> void:
	print("show settings")

func _on_new_game() -> void:
	print("new game")
