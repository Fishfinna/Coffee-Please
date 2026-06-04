# DialogueHandler.gd
extends Node

const BALLOON = preload("res://dialog/balloon.tscn")
var active := false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func show(dialogue_resource: Resource, title: String = "start", anchor: Node2D = null) -> void:
	if active:
		return
	active = true
	DialogueManager.show_dialogue_balloon_scene(BALLOON, dialogue_resource, title, [anchor])

func _on_dialogue_ended(_resource) -> void:
	active = false
