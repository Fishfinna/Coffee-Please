extends Node
class_name SaveSlot

var save_file := ""
var save_manager: SaveManager = SaveManager.new()
@onready var file_label: Label = $NameMargin/FileName
@onready var time_label: Label = $ModifiedMargin/ModifiedTime

@onready var players = get_tree().get_nodes_in_group("player")
@onready var player = players[0] if players.size() > 0 else null

@onready var delete_button = $delete
@onready var trash_open_icon := preload("res://assets/art/ui/icons/trash-opened.png")
@onready var trash_closed_icon := preload("res://assets/art/ui/icons/trash-closed.png")

signal deleted(file_name: String)

func setup(data: Dictionary) -> void:
	save_file = data.file
	file_label.text = data.file.split(".")[0]
	time_label.text = data.modified

func _delete() -> void:
	print("delete: ", save_file)
	save_manager.delete_save(save_file)
	emit_signal("deleted", save_file)

func _save_over() -> void:
	save_manager.save_game(player, save_file)

func _load_slot() -> void:
	var data = save_manager.load_game(save_file)
	if data != null:
		player.global_position = data.player_position
		Global.money = data.money

func _delete_hovered() -> void:
	delete_button.icon = trash_open_icon

func _delete_unhovered() -> void:
	delete_button.icon = trash_closed_icon
