extends CanvasLayer

@onready var blur_anim: AnimationPlayer = $blur
var is_transitioning := false

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
	show()

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

func _on_save_pressed() -> void:
	print("save")
