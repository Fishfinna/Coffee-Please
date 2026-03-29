extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		toggle_fullscreen()
	if event.is_action_pressed("exit_game"):
		exit()

func toggle_fullscreen():
	var mode := DisplayServer.window_get_mode()
	var is_fullscreen := (
		mode == DisplayServer.WINDOW_MODE_FULLSCREEN
		or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	)

	Settings.update_setting("fullscreen", !is_fullscreen)

func exit():
	get_tree().quit()
