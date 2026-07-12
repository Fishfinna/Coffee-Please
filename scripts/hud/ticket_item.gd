extends Panel
class_name TicketItem

@onready var icon: Sprite2D = $Image
@onready var item_label: Label = $Label

func set_item(item: Item) -> void:
	item_label.text = item.display_name
	icon.texture = load(item.image)
