class_name Interactable
extends Area2D

@export var interact_name := ""
@export var is_interactable := true

signal player_entered
signal player_exited

var interact: Callable = func():
	pass


func _ready() -> void:
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_entered.emit()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_exited.emit()
