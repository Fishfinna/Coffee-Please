extends Node2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if Dialog.active:
		return
	if interactable.is_interactable:
		indicator.play_audio()
		Dialog.start("sink")
