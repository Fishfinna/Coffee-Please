extends CanvasLayer

@export var save_slot_scene: PackedScene

@onready var blur_anim: AnimationPlayer = $blur
var is_transitioning := false

@onready var pause_menu = $pause
@onready var save_menu = $save
@onready var options_menu = $options

@onready var save_list = $save/scroll_saves/MarginContainer/VBoxContainer

@onready var player = get_tree().get_first_node_in_group("player")
@onready var customers = get_tree().get_nodes_in_group("customer")

@export var swipe_sound: AudioStream = preload("res://assets/audio/ui/swipe.mp3")
var fx_player: AudioStreamPlayer

var save_manager = SaveManager.new()

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

	fx_player = AudioStreamPlayer.new()
	fx_player.bus = "FX"
	add_child(fx_player)

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
	swap_menu(pause_menu, save_menu)
	display_saves()

func _on_save_back_pressed() -> void:
	swap_menu(save_menu, pause_menu)

func _on_options_menu_pressed() -> void:
	swap_menu(pause_menu, options_menu)

func _on_options_back_pressed() -> void:
	swap_menu(options_menu, pause_menu)

func _on_save_pressed() -> void:
	save_manager.save_game(player, customers)
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
	display_saves()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	Global.money = 100

func swap_menu(from_menu: Control, to_menu: Control) -> void:
	if not from_menu or not to_menu:
		return
	#fx_player.stream = swipe_sound
	#fx_player.play()

	from_menu.hide()
	to_menu.show()
