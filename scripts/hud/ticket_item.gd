extends Panel
class_name TicketItem

@onready var completed: Panel = $completed
@onready var icon: Sprite2D = $Image
@onready var item_label: Label = $Label

var item_data

func set_item(item: Item) -> void:
	item_data = item
	item_label.text = item.display_name
	icon.texture = load(item.image)

func complete() -> void:
	completed.visible = true
	print("completed:", item_data.display_name)
