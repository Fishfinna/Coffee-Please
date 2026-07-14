extends Node2D

@onready var indicator = $StaticBody2D/Indicator
@onready var sprite = $Sprite2D
@onready var interactable = $StaticBody2D/Interactable

#todo: store many items here
#var items: Array[Item] = []
var item = null

func _ready() -> void:
	interactable.interact = _on_interact
	
func place_item(new_item: Item):
	#items.append(item)
	item = new_item
	sprite.texture = load(item.image)

func _on_interact():
	indicator.play_audio()
	if Inventory.get_focused_item():
		place_item(Inventory.get_focused_item())
		Inventory.remove_focused_item()
