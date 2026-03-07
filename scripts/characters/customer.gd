extends CharacterBody2D

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

func set_status(new_status: CustomerStatus.order_status):
	status = new_status

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
