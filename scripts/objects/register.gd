extends Node2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator
@onready var purchase_audio := $Purchase_Audio

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if interactable.is_interactable:
		purchase_audio.play()
	else:
		indicator.play_audio()
