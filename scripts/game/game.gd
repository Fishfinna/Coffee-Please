extends Node2D

var customer_group = "customer"
@onready var player = get_tree().get_first_node_in_group("player")
@onready var register = get_node("Coffee Shop/environment/Register")

func get_state(filename: String = "") -> Dictionary:
	print(register.customer_line)
	return {
		"player": player,
		"customers": get_tree().get_nodes_in_group(customer_group),
		"register_line": register.customer_line,
		"filename": filename
	}
