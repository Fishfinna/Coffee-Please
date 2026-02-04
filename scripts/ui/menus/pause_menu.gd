extends CanvasLayer

#func resume():
	#get_tree().paused = false;
	#$blur.play_backwards("blur")
#
#func pause():
	#get_tree().paused = true;
	#$blur.play("blur")

#func escape():
	#if Input.is_action_just_pressed("exit_game") and get_tree().pause == false:
		#pause()
	#elif Input.is_action_just_pressed("exit_game") and get_tree().paused:
		#resume()
#
func _ready():
	hide() 
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _pause_game():
	get_tree().paused = true
	$blur.play("blur")
	show()

func _resume_game():
	get_tree().paused = false
	$blur.play_backwards("blur")
	hide()

func _on_resume_pressed() -> void:
	_resume_game()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_save_pressed() -> void:
	print("save")
