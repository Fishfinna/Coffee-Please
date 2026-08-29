extends Node2D

@onready var contine: Button = $Panel/Control/HBoxContainer/contine
var save_manager = SaveManager.new()

func _ready() -> void:
	contine.visible = false
	if len(save_manager.list_saves()):
		contine.visible = true

func _on_contine() -> void:
	var save_path = save_manager.list_saves()[0].file
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	save_manager.load_game(save_path)

func _on_new_game() -> void:
	Global.money = Global.default_starting_money
	get_tree().change_scene_to_file("uid://b7jj10uq4ivgs")
	
func _on_settings() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/settings.tscn")

func _on_exit() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
