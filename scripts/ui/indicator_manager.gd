extends Node

var active_indicators: Array[Indicator] = []
var current_indicator: Indicator = null
var enter_counter: int = 0


func register(indicator: Indicator) -> void:
	if active_indicators.has(indicator):
		return

	enter_counter += 1
	indicator.enter_id = enter_counter
	active_indicators.append(indicator)
	update_active()


func unregister(indicator: Indicator) -> void:
	if not active_indicators.has(indicator):
		return

	active_indicators.erase(indicator)

	if current_indicator == indicator:
		current_indicator.force_hide()
		current_indicator = null

	update_active()


func update_active() -> void:
	if active_indicators.is_empty():
		if current_indicator:
			current_indicator.force_hide()
			current_indicator = null
		return

	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	active_indicators.sort_custom(func(a: Indicator, b: Indicator) -> bool:
		var da := _distance_to_player(a, player)
		var db := _distance_to_player(b, player)

		if is_equal_approx(da, db):
			return a.enter_id > b.enter_id

		return da < db
	)

	var best := active_indicators[0]

	if current_indicator != best:
		if current_indicator:
			current_indicator.force_hide()

		current_indicator = best
		current_indicator.force_show()

func _distance_to_player(indicator: Indicator, player: Node2D) -> float:
	if indicator.interactable == null:
		return INF

	return indicator.interactable.global_position.distance_to(player.global_position)
