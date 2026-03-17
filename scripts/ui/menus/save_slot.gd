extends Node
class_name SaveSlot

var save_file := ""
var save_manager: SaveManager = SaveManager.new()
@onready var file_label: Label = $NameMargin/FileName
@onready var time_label: Label = $ModifiedMargin/ModifiedTime

@onready var player = get_tree().get_first_node_in_group("player")
@onready var customer_group = "customer"
@onready var register: Register = get_node("/root/Game/Coffee Shop/environment/Register")

@onready var game := get_tree().current_scene

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
	save_manager.save_game(game.get_state(save_file))

func _load_slot() -> void:
	var data = save_manager.load_game(save_file)
	if data == null:
		return
	register.is_loading = true

	for customer in get_tree().get_nodes_in_group(customer_group):
		customer.queue_free()

	player.global_position = data.player_position
	Global.money = data.money

	for customer in data.customers:
		var shop_node = get_node("/root/Game/Coffee Shop/environment")
		var inst = load(customer.scene).instantiate()
		shop_node.add_child(inst)
		inst.load_customer_data(customer)

	if register:
		register.customer_line = data.register_line
		register.interactable.is_interactable = not register.customer_line.is_empty()

	await get_tree().process_frame
	register.is_loading = false
		
func _delete_hovered() -> void:
	if delete_button:
		delete_button.icon = trash_open_icon

func _delete_unhovered() -> void:
	if delete_button:
		delete_button.icon = trash_closed_icon
