extends Node2D

@onready var interactable = $StaticBody2D/Interactable
const MAIN_MENU = "res://scenes/ui/menus/main-menu.tscn"

func customer_entered(customer: Customer) -> void:
	print(customer.status, CustomerStatus.order_status.RECIEVED, customer.status == CustomerStatus.order_status.RECIEVED)
	if customer.status == CustomerStatus.order_status.RECIEVED:
		customer.queue_free()


func player_entered() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
