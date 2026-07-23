extends Node2D
@onready var interactable: Area2D = $StaticBody2D/Interactable
@onready var indicator: Indicator = $StaticBody2D/Indicator
@onready var espresso_grind: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if not interactable.is_interactable:
		return
	var coffee: Item = Items.get_item(&"coffee")
	var added = Inventory.pickup(coffee)
	if added:
		espresso_grind.play()
	else:
		indicator.play_audio()
