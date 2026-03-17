extends CharacterBody2D
class_name Customer

var id: String
var movement_speed = 50.0
var status = CustomerStatus.order_status.TO_PLACE

@export var target: Node2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var sprite = $NoraBase

var stuck_timer = 0.0
var last_position = Vector2.ZERO
const STUCK_THRESHOLD = 2.0
const STUCK_TIME = 0.2


func _ready() -> void:
	call_deferred("seeker_setup")
	print("before:", id)
	if id == "" or id == null:
		id = str(randi(), "_", Time.get_ticks_usec())
	print("after:", id)
	CustomerRegistry.register(self)

func _exit_tree():
	CustomerRegistry.unregister(self)

func set_status(new_status: CustomerStatus.order_status):
	status = new_status
	print("updated status:", status)

func seeker_setup():
	await get_tree().physics_frame
	navigation_agent_2d.target_desired_distance = 30.0
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
	if global_position.distance_to(last_position) < STUCK_THRESHOLD * delta:
		stuck_timer += delta
	else:
		stuck_timer = 0.0
	last_position = global_position
	if stuck_timer >= STUCK_TIME:
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
		move_and_slide()
		sprite.flip_h = true if velocity.x > 0 else false
		return
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()
	sprite.flip_h = true if velocity.x > 0 else false
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.lerp(safe_velocity, 0.25)

func _restore_target(path: NodePath) -> void:
	if has_node(path):
		target = get_node(path)
		
func get_customer_data() -> Dictionary:
	var data := {
		"id": id,
		"scene": scene_file_path,
		"transform": global_transform,
		"z_index": z_index,
		"movement_speed": movement_speed,
		"status": status,
		"target_path": target.get_path() if target else NodePath()
	}
	return data

func load_customer_data(data: Dictionary) -> void:
	CustomerRegistry.unregister(self)
	id = data.id
	global_transform = data.transform
	z_index = data.z_index
	movement_speed = data.movement_speed
	status = data.status
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	if data.target_path != NodePath():
		call_deferred("_restore_target", data.target_path)

	CustomerRegistry.register(self)
	print(CustomerRegistry.by_id)
		
		
