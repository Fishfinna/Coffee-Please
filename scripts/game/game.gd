extends Node2D

var customer_group = "customer"
@onready var player = get_tree().get_first_node_in_group("player")

func get_state(filename: String = "") -> Dictionary:
	return {
		"player": player,
		"customers": get_tree().get_nodes_in_group(customer_group),
		"filename": filename
	}
