extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

func get_state(filename: String = "") -> Dictionary:
	return {
		"player": player,
		"filename": filename
	}

func found():
	print
