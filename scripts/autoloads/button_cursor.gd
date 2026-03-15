extends Node

var hover_sound: AudioStream
var click_sound: AudioStream

var fx_player: AudioStreamPlayer

func _ready():
	hover_sound = load("res://assets/audio/ui/button-hover.wav")
	click_sound = load("res://assets/audio/ui/button-click.wav")

	set_cursor_for_buttons(get_tree().get_root())
	get_tree().connect("node_added", Callable(self, "_on_node_added"))

	fx_player = AudioStreamPlayer.new()
	fx_player.bus = "FX"
	add_child(fx_player)

func set_cursor_for_buttons(node):
	if node is Button:
		node.mouse_filter = Control.MOUSE_FILTER_STOP
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)
	for child in node.get_children():
		set_cursor_for_buttons(child)

func _on_node_added(node):
	if node is Button:
		node.mouse_filter = Control.MOUSE_FILTER_STOP
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _play_hover() -> void:
	if hover_sound:
		fx_player.stream = hover_sound
		fx_player.volume_linear = 0.4
		fx_player.play()

func _play_pressed() -> void:
	if click_sound:
		fx_player.stream = click_sound
		fx_player.volume_linear = 0.3
		fx_player.play()
