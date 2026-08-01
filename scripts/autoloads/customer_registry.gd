extends Node

var by_id := {}
var customer_scene: PackedScene = preload("uid://dojgtwkuwtlhk")

func register(customer: Customer) -> void:
	if customer.id == "":
		push_error("Customer missing ID")
		return
	by_id[customer.id] = customer

func unregister(customer: Customer) -> void:
	if by_id.get(customer.id) == customer:
		by_id.erase(customer.id)

func get_customer(id: String) -> Customer:
	return by_id.get(id)

func create_customer():
	# TODO: Clean this up! make a customer setup that does this and move target management to the customer
	print("create customer")
	var customer: Customer = customer_scene.instantiate()
	var scene_root = get_tree().current_scene
	var placed_scene = scene_root.get_node("Coffee Shop/environment")
	placed_scene.add_child(customer)
	customer.global_position = Vector2(550, 255)
	customer.aquire_target(scene_root.get_node("Coffee Shop/environment/Register"))
	
	#for save in saves:
		#var slot: SaveSlot = save_slot_scene.instantiate()
		#save_list.add_child(slot)
		#slot.setup(save)
		#slot.deleted.connect(_on_save_deleted)
	#
