extends CharacterBody2D
class_name Customer

var id: String
var movement_speed = 200.0
var default_starting_position = Vector2(550, 255)
var status = CustomerStatus.order_status.TO_PLACE
var order: Array[Item] = []
const MenuItems = preload("uid://cdnt7p2irvk7i")

var target: Node2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var sprite = $Sprite

@onready var register = get_node("../Register")
@onready var pickup = get_node("../Pickup")
@onready var door = get_node("../Door")
@onready var ticket_board: TicketBoard = get_node("../../../Hud/TicketBoard")

func _ready() -> void:
	setup()

func kick_off():
	global_position = default_starting_position
	aquire_target(register)
	
func setup() -> void:
	if id == "" or id == null:
		id = str(randi(), "_", Time.get_ticks_usec())
	var drink_count: int = get_weighted_drink_count()
	for i in range(drink_count):
		var ordered_item: Item = MenuItems.DRINKS.pick_random()
		order.append(ordered_item)
	CustomerRegistry.register(self)
	call_deferred("seeker_setup")
	aquire_target(register)

func _exit_tree():
	CustomerRegistry.unregister(self)

func get_weighted_drink_count() -> int:
	var roll: float = randf() * 100.0
	if roll < 20.0:
		return 1
	elif roll < 80.0:
		return 2
	elif roll < 95.0:
		return 3
	else:
		return 4
		
func set_status(new_status: CustomerStatus.order_status):
	status = new_status
	if new_status == CustomerStatus.order_status.PLACED:
		aquire_target(pickup)
	elif new_status == CustomerStatus.order_status.RECIEVED:
		aquire_target(door)

func seeker_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position

func aquire_target(new_target: Node2D):
	target = new_target

func _physics_process(delta: float) -> void:
	if target:
		navigation_agent_2d.target_position = target.global_position
	if navigation_agent_2d.is_navigation_finished():
		return
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()
	sprite.flip_h = true if velocity.x > 0 else false

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.lerp(safe_velocity, 0.25)


func handle_item_pickup(item: Item) -> void:
	print("to customer", item)
	if !len(order):
		return
	ticket_board.mark_item_complete(id, item)
