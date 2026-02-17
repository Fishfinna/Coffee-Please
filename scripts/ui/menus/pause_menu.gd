extends CanvasLayer

@export var save_slot_scene: PackedScene

@onready var blur_anim: AnimationPlayer = $blur
var is_transitioning := false

@onready var pause_menu = $pause
@onready var save_menu = $save
@onready var options_menu = $options

@onready var save_list = $save/scroll_saves/MarginContainer/VBoxContainer

@onready var players = get_tree().get_nodes_in_group("player")
@onready var player = players[0] if players.size() > 0 else null

var save_manager = SaveManager.new()

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not is_transitioning:
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _pause_game():
	is_transitioning = true
	pause_menu.show()
	save_menu.hide()
	options_menu.hide()
	show()
	blur_anim.play("blur")
	await blur_anim.animation_finished

	get_tree().paused = true
	is_transitioning = false

func _resume_game():
	is_transitioning = true
	hide()
	get_tree().paused = false
	is_transitioning = false

func _on_resume_pressed() -> void:
	if not is_transitioning:
		_resume_game()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_save_menu_pressed() -> void:
	pause_menu.hide()
	save_menu.show()
	display_saves()

func _on_save_back_pressed() -> void:
	save_menu.hide()
	pause_menu.show()

func _on_save_pressed() -> void:
	save_manager.save_game(player)
	print("saved")
	display_saves()
	
func display_saves() -> void:
	if not save_menu.is_visible_in_tree():
		return
	for child in save_list.get_children():
		child.queue_free()

	var saves := save_manager.list_saves()

	for save in saves:
		var slot: SaveSlot = save_slot_scene.instantiate()
		save_list.add_child(slot)
		slot.setup(save)
		slot.deleted.connect(_on_save_deleted)

func _on_save_deleted(file_name: String) -> void:
	display_saves()  # refresh the list

func _on_restart_pressed() -> void:
	var current_scene := get_tree().current_scene
	get_tree().paused = false
	get_tree().reload_current_scene()
	Global.money = 100

func _on_options_menu_pressed() -> void:
	pause_menu.hide()
	options_menu.show()
	
func _on_options_back_pressed() -> void:
	options_menu.hide()
	pause_menu.show()
