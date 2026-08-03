extends CharacterBody2D
class_name Customer

var id: String
var movement_speed = 500.0
var default_starting_position = Vector2(550, 255)
var status = CustomerStatus.order_status.TO_PLACE
var order: Array[Item] = []
const MenuItems = preload("uid://cdnt7p2irvk7i")

var target: Node2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var sprite = $Sprite

@onready var register = get_node("../Register")
@onready var pickup = get_node("../Pickup")

func _ready() -> void:
	setup()

func kick_off():
	global_position = default_starting_position
	aquire_target(register)
	
func setup() -> void:
	if id == "" or id == null:
		id = str(randi(), "_", Time.get_ticks_usec())

	var ordered_item: Item = MenuItems.DRINKS.pick_random()
	order.append(ordered_item)
	CustomerRegistry.register(self)
	call_deferred("seeker_setup")
	aquire_target(register)

func _exit_tree():
	CustomerRegistry.unregister(self)

func set_status(new_status: CustomerStatus.order_status):
	status = new_status
	if new_status == CustomerStatus.order_status.PLACED:
		aquire_target(pickup)
	print(new_status)

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
