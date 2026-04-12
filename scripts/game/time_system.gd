class_name TimeSystem extends Node

@export var date_time: DateTime
@export var ticks_pr_second: int = 6

func _process(delta: float) -> void:
	date_time.increase_by_sec(delta * ticks_pr_second)
