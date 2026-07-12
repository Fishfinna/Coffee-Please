# item.gd
class_name Item
extends RefCounted

var id: StringName
var display_name: String
var unlocked: bool
var price: int
var image: String

func _init(
	p_id: StringName,
	p_display_name: String,
	p_unlocked: bool = false,
	p_price: int = 0,
	p_image: String = "res://assets/art/items/coffee.png"
) -> void:
	id = p_id
	display_name = p_display_name
	unlocked = p_unlocked
	price = p_price
	image = p_image
