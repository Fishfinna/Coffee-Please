extends CharacterBody2D

var movement_speed = 50.0
@export var target: Node2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var sprite = $NoraBase

func _ready() -> void:
	call_deferred("seeker_setup")

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
	
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()
	sprite.flip_h = true if velocity.x > 0 else false

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
