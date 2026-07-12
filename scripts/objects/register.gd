extends Node2D
class_name Register

@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator
@onready var purchase_audio := $Purchase_Audio
@onready var pick_up_area = $"../Pickup"
@onready var ticket_board = get_node("../../../Hud/TicketBoard")
const MenuItems = preload("uid://cdnt7p2irvk7i")

var customer_line: Array[String] = []
var is_loading := false

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if not interactable.is_interactable:
		indicator.play_audio()
		return
	if customer_line.is_empty():
		interactable.is_interactable = false
		return
	purchase_audio.play()
	var id = customer_line.pop_front()
	var customer = get_customer(id)
	if customer == null:
		return
	place_customer_order(customer)
	customer.target = pick_up_area
	if customer_line.is_empty():
		interactable.is_interactable = false

func place_customer_order(customer: Node) -> void:
	customer.set_status(CustomerStatus.order_status.PLACED)
	var ordered_item: Item = MenuItems.DRINKS.pick_random()
	var ticket := {
		"_id": customer.id,
		"name": "Nora",
		"timestamp": {
			"hour": DaytimeClock.current_hour,
			"minute": DaytimeClock.current_minute
		},
		"items": [ordered_item.id]
	}
	Global.money += ordered_item.price
	ticket_board.add_ticket(ticket)

func customer_entered(customer: Node) -> void:
	if customer.id in customer_line:
		return
	if customer.status != CustomerStatus.order_status.TO_PLACE:
		return
	customer_line.append(customer.id)
	customer.set_status(CustomerStatus.order_status.IN_LINE)
	interactable.is_interactable = true

func customer_exited(customer: Node) -> void:
	if is_loading:
		return
	customer_line.erase(customer.id)
	if customer_line.is_empty():
		interactable.is_interactable = false

func get_customer(id: String) -> Customer:
	return CustomerRegistry.get_customer(id)
