extends Node2D

@onready var indicator = $StaticBody2D/Indicator
@onready var sprite = $Sprite2D
@onready var interactable = $StaticBody2D/Interactable

@onready var ticket_board = get_node("../../../Hud/TicketBoard")
@onready var next_target = $"../Register"

#todo: store many items here
#var items: Array[Item] = []
var item = null
var waiting_customers = []

func _ready() -> void:
	interactable.interact = _on_interact
	
func place_item(new_item: Item):
	#items.append(item)
	item = new_item
	sprite.texture = load(item.image)
	await get_tree().create_timer(.4).timeout
	customer_picks_up_item(get_customer(waiting_customers[0]))

func remove_item():
	item = null
	sprite.texture = null

func _on_interact():
	indicator.play_audio()
	if Inventory.get_focused_item():
		place_item(Inventory.get_focused_item())
		Inventory.remove_focused_item()

func get_customer(id: String) -> Customer:
	return CustomerRegistry.get_customer(id)
	
func customer_picks_up_item(customer: Customer) -> bool:
	if item and item in customer.order:
		customer.order.erase(item)
		remove_item()
		if len(customer.order) == 0 and customer.id in waiting_customers:
			waiting_customers.erase(customer.id)
			ticket_board.remove_ticket(customer.id)
			customer.set_status(CustomerStatus.order_status.RECIEVED)
			customer.aquire_target(next_target)
		return true
	return false

func customer_entered(customer: Node) -> void:
	waiting_customers.append(customer.id)
	customer_picks_up_item(customer)
