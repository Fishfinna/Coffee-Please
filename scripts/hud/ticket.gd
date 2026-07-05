extends PanelContainer
class_name Ticket

var creation_time: Timer

@onready var order_name: Label = $order_name

func setup(ticket_data: Dictionary) -> void:
	print(ticket_data)

	var order_id: String = ticket_data.get("_id", "")
	var customer_name: String = ticket_data.get("name", "Unknown")
	var timestamp: Dictionary = ticket_data.get("timestamp", {})
	var hour: int = timestamp.get("hour", 0)
	var minute: int = timestamp.get("minute", 0)
	var items: Array = ticket_data.get("items", [])

	order_name.text = customer_name

	for item in items:
		var item_name: String = item.get("name", "")
		var unlocked: bool = item.get("unlocked", false)
		# do something with each item
