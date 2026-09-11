class_name Person
extends CharacterBody2D

@export var bumpable: bool = true
@export var bump_force: float = 20.0
@export var knockback_decay: float = 2.0
@export var max_knockback: float = 40.0
@export var bump_cooldown: float = 0.3

var knockback: Vector2 = Vector2.ZERO
var _recent_bumps: Dictionary = {}

func _physics_process(delta: float) -> void:
	knockback = knockback.lerp(Vector2.ZERO, clamp(knockback_decay * delta, 0.0, 1.0))
	if knockback.length() > 1.0:
		move_and_collide(knockback * delta)
	else:
		knockback = Vector2.ZERO

	for id in _recent_bumps.keys():
		_recent_bumps[id] -= delta
		if _recent_bumps[id] <= 0.0:
			_recent_bumps.erase(id)

func apply_bump(from_position: Vector2, force: float = -1.0, source: Object = null) -> void:
	if not bumpable:
		return
	if source != null:
		var id = source.get_instance_id()
		if _recent_bumps.has(id):
			return
		_recent_bumps[id] = bump_cooldown
	var actual_force = force if force >= 0.0 else bump_force
	var dir = (global_position - from_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT.rotated(randf() * TAU)
	knockback = (knockback + dir * actual_force).limit_length(max_knockback)

func handle_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Person:
			collider.apply_bump(global_position, -1.0, self)
