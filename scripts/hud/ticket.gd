extends PanelContainer
class_name Ticket

var creation_time: Timer

@onready var ticket_board: TicketBoard = get_node("../../../../../TicketBoard")

@onready var order_name: Label = $order_name
@onready var wait_time: Label = $time_margin/wait_time

var created_hour: int
var created_minute: int

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
	var order_id: String = ticket_data.get("_id", "")
	var customer_name: String = ticket_data.get("name", "Unknown")
	var timestamp: Dictionary = ticket_data.get("timestamp", {})
	created_hour = timestamp.get("hour", 0)
	created_minute = timestamp.get("minute", 0)
	var items: Array = ticket_data.get("items", [])

	order_name.text = customer_name

	for item in items:
		var item_name: String = item.get("name", "")
		var unlocked: bool = item.get("unlocked", false)
