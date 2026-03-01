extends Node2D
@onready var interactable: Area2D = $Interactable
@onready var indicator: Indicator = $body/Indicator
@onready var purchase_audio := $Purchase_Audio
@onready var pick_up_area = $"../Sink"

var customer_line: Array = []

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if interactable.is_interactable:
		purchase_audio.play()
		Global.money += 1
		var customer = customer_line[0]
		customer_line.erase(customer)
		if customer_line.is_empty():
			interactable.is_interactable = false
		customer.target = pick_up_area
	else:
		indicator.play_audio()

func customer_entered(customer: Node) -> void:
	if customer not in customer_line:
		customer_line.append(customer)
		
	if not customer_line.is_empty():
		print(len(customer_line))
		interactable.is_interactable = true


func customer_exited(customer: Node) -> void:
	if customer in customer_line:
		customer_line.erase(customer)

	if customer_line.is_empty():
		interactable.is_interactable = false
