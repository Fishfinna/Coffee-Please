extends Node2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if not interactable.is_interactable:
		return
	indicator.play_audio()
	var water: Item = Items.get_item(&"water")
	var added = Inventory.pickup(water)
