extends CharacterBody2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $Indicator

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if interactable.is_interactable:
		indicator.play_audio()
		print("you have $%d" % [Global.money])
