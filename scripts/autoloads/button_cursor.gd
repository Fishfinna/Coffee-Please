extends Node

var hover_sound: AudioStream
var click_sound: AudioStream
var fx_player: AudioStreamPlayer

func _ready():
	hover_sound = load("res://assets/audio/ui/button-hover.wav")
	click_sound = load("res://assets/audio/ui/button-click.wav")
	fx_player = AudioStreamPlayer.new()
	fx_player.bus = "FX"
	add_child(fx_player)
	set_cursor_for_buttons(get_tree().get_root())
	get_tree().node_added.connect(_on_node_added)

func set_cursor_for_buttons(node):
	if node is Button:
		_setup_button(node)
	for child in node.get_children():
		set_cursor_for_buttons(child)

func _on_node_added(node):
	if node is Button:
		_setup_button(node)

func _setup_button(node: Button) -> void:
	node.mouse_filter = Control.MOUSE_FILTER_STOP
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	if not node.mouse_entered.is_connected(_play_hover):
		node.mouse_entered.connect(_play_hover)
	if not node.pressed.is_connected(_play_pressed):
		node.pressed.connect(_play_pressed)

func _play_hover() -> void:
	if hover_sound and is_instance_valid(fx_player):
		fx_player.stream = hover_sound
		fx_player.volume_linear = 0.4
		fx_player.play()

func _play_pressed() -> void:
	if click_sound and is_instance_valid(fx_player):
		fx_player.stream = click_sound
		fx_player.volume_linear = 0.3
		fx_player.play()
