extends CharacterBody2D

@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $Indicator

var test = preload("res://dialog/test.dialogue")

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if interactable.is_interactable and not Dialog.active:
		indicator.play_audio()
		Dialog.show(test, "start", self)
