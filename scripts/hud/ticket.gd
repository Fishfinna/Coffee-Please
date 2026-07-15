extends PanelContainer
class_name Ticket

const ItemRowScene := preload("res://scenes/ui/hud-components/ticket-item.tscn")

var creation_time: Timer
var id: String

@onready var ticket_board: TicketBoard = get_node("../../../../../TicketBoard")
@onready var order_name: Label = $order_name
@onready var wait_time: Label = $time_margin/wait_time
@onready var items_container: HFlowContainer = $MarginContainer/HFlowContainer

var created_hour: int
var created_minute: int
var order_items: Array[Item] = []

func _ready() -> void:
	DaytimeClock.time_changed.connect(_on_time_changed)

func _on_time_changed(current_hour: int, current_minute: int) -> void:
	var wait_time_str = ""
	var created_total_minutes = created_hour * 60 + created_minute
	var current_total_minutes = current_hour * 60 + current_minute
	var elapsed_minutes = current_total_minutes - created_total_minutes
	if elapsed_minutes < 0:
		elapsed_minutes += 12 * 60
	var waited_hours = elapsed_minutes / 60
	var waited_minutes = elapsed_minutes % 60
	if waited_hours > 0:
		wait_time_str = "%dh %dmin" % [waited_hours, waited_minutes]
	else:
		wait_time_str = "%dmin" % waited_minutes
	wait_time.text = wait_time_str

func setup(ticket_data: Dictionary) -> void:
	id = ticket_data.get("_id", "Unknown")
	var customer_name: String = ticket_data.get("name", "Unknown")
	var timestamp: Dictionary = ticket_data.get("timestamp", {})
	created_hour = timestamp.get("hour", 0)
	created_minute = timestamp.get("minute", 0)
	order_name.text = customer_name

	var items: Array = ticket_data.get("items", [])
	order_items.clear()

	for child in items_container.get_children():
		child.queue_free()

	for item in items:
		order_items.append(item)
		var row: TicketItem = ItemRowScene.instantiate()
		items_container.add_child(row)
		row.set_item(item)
