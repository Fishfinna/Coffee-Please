extends NinePatchRect
class_name TicketBoard

signal toggled_menu(is_open: bool)

@onready var toggle: TextureButton = $toggle
var is_open: bool = false
var starting_position: float
var open_padding = 16

@export var ticket_scene: PackedScene
@onready var ticket_list: VBoxContainer = %TicketList
var tickets: Array = []

func _ready():
	starting_position = position.y
	toggle.focus_mode = Control.FOCUS_NONE

func _unhandled_input(event):
	if event.is_action_pressed("toggle-tickets"):
		_on_toggle_tickets()

func _on_toggle_tickets() -> void:
	if is_open:
		position.y = starting_position
	else:
		position.y = size.y - open_padding

	is_open = !is_open
	emit_signal("toggled_menu", is_open)

	toggle.flip_v = !toggle.flip_v

func add_ticket(ticket_data: Dictionary) -> void:
	var ticket: Ticket = ticket_scene.instantiate()
	ticket_list.add_child(ticket)
	ticket.setup(ticket_data)

	
