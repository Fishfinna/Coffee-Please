class_name Interactable
extends Area2D

@export var interact_name := ""
@export var is_interactable := false

signal player_entered
signal player_exited

signal customer_entered
signal customer_exited

var interact: Callable = func():
	print("I am a sink!")


func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_entered.emit()
	
	if body.is_in_group("customer"):
		customer_entered.emit(body)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_exited.emit()
	
	if body.is_in_group("customer"):
		customer_exited.emit(body)
