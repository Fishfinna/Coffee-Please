extends CharacterBody2D

var movement_speed: float = 50.0
@export var target: Node2D
@export var catch_radius: float = 8.0
@export var slowing_radius: float = 32.0

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
	if not target:
		return

	var distance_to_target = global_position.distance_to(target.global_position)

	if distance_to_target <= catch_radius:
		velocity = Vector2.ZERO
		move_and_slide()
		sprite.flip_h = velocity.x > 0
		return

	navigation_agent_2d.target_position = target.global_position

	if navigation_agent_2d.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		sprite.flip_h = velocity.x > 0
		return

	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)

	var speed = movement_speed
	if distance_to_target < slowing_radius:
		speed *= distance_to_target / slowing_radius  # linearly reduce speed

	var new_velocity = direction * speed

	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

	move_and_slide()
	sprite.flip_h = velocity.x > 0

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
