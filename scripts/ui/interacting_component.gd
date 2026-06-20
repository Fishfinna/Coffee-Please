extends Node2D
@onready var interact_label: Label = $InteractLabel
var current_interactions: Array[Interactable] = []
var can_interact := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		var target := _get_nearest_interactable()
		if target:
			can_interact = false
			interact_label.hide()
			
			await target.interact.call()
			can_interact = true

func _process(_delta: float) -> void:
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		var target := _get_nearest_interactable()
		if target:
			interact_label.text = target.interact_name
			interact_label.show()
			return
	interact_label.hide()

func _get_nearest_interactable() -> Interactable:
	for area in current_interactions:
		if area.is_interactable:
			return area
	return null

func _sort_by_nearest(area1: Interactable, area2: Interactable) -> bool:
	var area1_dist = global_position.distance_squared_to(area1.global_position)
	var area2_dist = global_position.distance_squared_to(area2.global_position)
	return area1_dist < area2_dist

func _on_interact_range_area_entered(area: Area2D) -> void:
	if area is Interactable:
		current_interactions.push_back(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)
