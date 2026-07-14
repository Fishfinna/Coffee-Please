extends Node

signal item_added(slot_index: int, item: Item)
signal item_removed(slot_index)
signal focus_changed(new_slot: int)

var inventory: Array[Item] = [null, null]
var focused_slot: int = 0

func pickup(item: Item) -> bool:
	if inventory[focused_slot] == null:
		inventory[focused_slot] = item
		item_added.emit(focused_slot, item)
		return true
	else:
		for i in inventory.size():
			if inventory[i] == null:
				inventory[i] = item
				item_added.emit(i, item)
				return true
	return false

func remove_focused_item():
	inventory[focused_slot] = null
	item_removed.emit(focused_slot)

func get_focused_item() -> Item:
	return inventory[focused_slot]

func set_focus(index: int) -> void:
	if index == focused_slot:
		return
	focused_slot = index
	focus_changed.emit(index)
