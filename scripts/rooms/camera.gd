extends Camera2D

@export var dead_zone_ratio: float = 1.0 / 1.5
@export var follow_speed: float = 8.0

var player: Node2D
var home_y: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	home_y = global_position.y
	limit_bottom = 210

func _process(delta: float) -> void:
	if not player:
		return

	var viewport_height = get_viewport_rect().size.y
	var dead_zone_extent = (viewport_height / 2.0) * dead_zone_ratio

	var target_y: float

	if player.position.y > dead_zone_extent:
		target_y = player.position.y - dead_zone_extent
	elif player.position.y < -dead_zone_extent:
		target_y = player.position.y + dead_zone_extent
	else:
		target_y = home_y

	position.y = lerp(position.y, target_y, follow_speed * delta)
