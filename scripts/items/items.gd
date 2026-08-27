# items.gd
extends Object
class_name Items

static var DRINKS: Array[Item] = [
	Item.new(&"water", "Water", true, 0, "res://assets/art/items/water.png", 1),
	Item.new(&"coffee", "Coffee", true, 3, "res://assets/art/items/coffee.png", 3),
]

static var FOOD: Array[Item] = []

static var OTHER: Array[Item] = [
	Item.new(&"cup", "Cup", true, 0, "res://assets/art/items/cup.png"),
]

static var _by_id: Dictionary = {}

static func _static_init() -> void:
	for item in DRINKS + FOOD + OTHER:
		_by_id[item.id] = item

static func get_item(id: StringName) -> Item:
	return _by_id.get(id)

static func get_random_item(pool: Array[Item]) -> Item:
	var total_weight := 0
	for item in pool:
		total_weight += item.popularity
	
	var roll := randi_range(1, total_weight)
	var cumulative := 0
	for item in pool:
		cumulative += item.popularity
		if roll <= cumulative:
			return item
	
	return pool[-1] # fallback, shouldn't be reached
