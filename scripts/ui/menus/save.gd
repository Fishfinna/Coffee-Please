extends Control

@onready var save_list = $scroll_saves/MarginContainer/VBoxContainer
@export var save_slot_scene: PackedScene
var save_manager = SaveManager.new()

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if visible:
		display_saves()
		
func _on_save_pressed() -> void:
	display_saves()
	
func display_saves() -> void:
	for child in save_list.get_children():
		child.queue_free()

	var saves := save_manager.list_saves()
	for save in saves:
		var slot: SaveSlot = save_slot_scene.instantiate()
		save_list.add_child(slot)
		slot.setup(save)
		slot.deleted.connect(_on_save_deleted)

func _on_save_deleted(file_name: String) -> void:
	display_saves()
