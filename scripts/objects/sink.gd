extends Node2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator

func _ready() -> void:
	interactable.interact = _on_interact

func _process(delta: float) -> void:
	if Inventory.get_focused_item():
		interactable.interact_name = "pour out"
	else:
		interactable.interact_name = ""

func _on_interact():
	if not interactable.is_interactable:
		return
	indicator.play_audio()
	var water: Item = Items.get_item(&"water")
	if Inventory.get_focused_item():
		Inventory.remove_focused_item() #pour out
	else:
		var added = Inventory.pickup(water)
