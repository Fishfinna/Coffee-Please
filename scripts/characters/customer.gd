extends CharacterBody2D

@onready var tilemap = $"../../tiles/TileMapLayer"

var current_path: Array[Vector2i] = []
var speed := 200.0

func _physics_process(delta: float) -> void:
	if current_path.is_empty():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var target_position = tilemap.map_to_local(current_path.front())
	var direction = (target_position - global_position)

	if direction.length() < 2.0:
		current_path.pop_front()
		velocity = Vector2.ZERO
	else:
		velocity = direction.normalized() * speed

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var click_position := get_global_mouse_position()

		if tilemap.is_point_walkable(click_position):
			current_path = tilemap.astar.get_id_path(
				tilemap.local_to_map(global_position),
				tilemap.local_to_map(click_position)
			).slice(1)
