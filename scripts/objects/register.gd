extends Node2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator
@onready var purchase_audio := $Purchase_Audio

var customer_line: Array = []

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if interactable.is_interactable:
		purchase_audio.play()
		Global.money += 1
	else:
		indicator.play_audio()

func customer_entered(customer: Node) -> void:
	print("customer!")
	if customer not in customer_line:
		customer_line.append(customer)
		print("Customer entered:", customer)
		
	if len(customer_line):
		print(len(customer_line))
		interactable.is_interactable = true
	
	
