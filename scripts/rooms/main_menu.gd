extends Node2D
signal new_game_pressed
signal continue_game_pressed

@onready var contine: Button = $Panel/Buttons/HBoxContainer/contine
@onready var coffee: Sprite2D = $Coffee

@onready var settings: Control = $Panel/Settings
@onready var button_panel: Control = $Panel/Buttons

var save_manager = SaveManager.new()

func _ready() -> void:
	contine.visible = false
	if len(save_manager.list_saves()):
		contine.visible = true

func _on_contine() -> void:
	var save_path = save_manager.list_saves()[0].file
	save_manager.load_game(save_path)
#	TODO: get this hooked in
	#emit_signal("continue_game_pressed")
	

func _on_new_game() -> void:
	emit_signal("new_game_pressed")

func _on_settings() -> void:
	settings.visible = true
	button_panel.visible = false
	
func _on_exit() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta):
	coffee.look_at(get_global_mouse_position())
	coffee.rotation -= PI / 2


func _on_settings_redirect_back() -> void:
	settings.visible = false
	button_panel.visible = true
