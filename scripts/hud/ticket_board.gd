extends NinePatchRect
class_name TicketBoard

signal toggled_menu(is_open: bool)

@onready var toggle: TextureButton = $toggle
@onready var move_sound_player: AudioStreamPlayer = AudioStreamPlayer.new()
var paper_sound: AudioStream = preload("res://assets/audio/ui/paper.wav")

@export var animation_duration: float = 0.3
@export var animation_transition: Tween.TransitionType = Tween.TRANS_CUBIC
@export var animation_ease: Tween.EaseType = Tween.EASE_OUT

var tween: Tween

var is_open: bool = false
var starting_position: float
var open_padding = 16

@export var ticket_scene: PackedScene
@onready var ticket_list: VBoxContainer = %TicketList
var tickets: Array = []

func _ready():
	starting_position = position.y
	toggle.focus_mode = Control.FOCUS_NONE
	move_sound_player.bus = "FX"
	add_child(move_sound_player)

func _unhandled_input(event):
	if event.is_action_pressed("toggle-tickets"):
		_on_toggle_tickets()

func _on_toggle_tickets() -> void:
	var target_y: float
	if is_open:
		target_y = starting_position
	else:
		target_y = size.y - open_padding

	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_trans(animation_transition)
	tween.set_ease(animation_ease)
	tween.tween_property(self, "position:y", target_y, animation_duration)

	move_sound_player.stream = paper_sound
	move_sound_player.volume_linear = 0.5
	move_sound_player.play()
	
	is_open = !is_open
	emit_signal("toggled_menu", is_open)
	toggle.flip_v = !toggle.flip_v

func add_ticket(ticket_data: Dictionary) -> void:
	var ticket: Ticket = ticket_scene.instantiate()
	ticket_list.add_child(ticket)
	ticket.setup(ticket_data)

	
