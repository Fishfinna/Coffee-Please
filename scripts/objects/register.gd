extends Node2D
class_name Register

@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator
@onready var purchase_audio := $Purchase_Audio
@onready var pick_up_area = $"../Sink"

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
	Global.money += 1

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
