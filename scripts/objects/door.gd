extends Node2D

@onready var interactable = $StaticBody2D/Interactable
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const MAIN_MENU = "res://scenes/ui/menus/main-menu.tscn"


func customer_entered(customer: Customer) -> void:
	if customer.status == CustomerStatus.order_status.RECIEVED:
		customer.queue_free()
		audio_stream_player_2d.play()
		CustomerRegistry.create_customer()

func player_entered() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
