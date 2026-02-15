extends CanvasLayer

@onready var blur_anim: AnimationPlayer = $blur
var is_transitioning := false

@onready var pause_menu = $pause
@onready var save_menu = $save
@onready var save_list = $save/scroll_saves

@onready var players = get_tree().get_nodes_in_group("player")
@onready var player = players[0] if players.size() > 0 else null

var save_manager = SaveManager.new()

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	save_menu.connect("visibility_changed", Callable(self, "_display_saves"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not is_transitioning:
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _pause_game():
	is_transitioning = true
	show()
	pause_menu.show()
	save_menu.hide()
	blur_anim.play("blur")
	await blur_anim.animation_finished

	get_tree().paused = true
	is_transitioning = false

func _resume_game():
	is_transitioning = true

	blur_anim.play_backwards("blur")
	await blur_anim.animation_finished

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
	print("hide")
	save_menu.show()

func _on_save_back_pressed() -> void:
	save_menu.hide()
	pause_menu.show()

func _on_save_pressed() -> void:
	save_manager.save_game(player)
	print("saved")

func _on_load_pressed() -> void:
	var data = save_manager.load_game()
	if data != null:
		player.global_position = data.player_position
		Global.money = data.money
	
func _display_saves() -> void:
	if save_list:
		print("show saves")
		print(save_manager.list_saves())


		
	
