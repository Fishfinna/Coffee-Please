extends Node

var active_indicators: Array[Indicator] = []
var current_indicator: Indicator = null
var enter_counter: int = 0


func register(indicator: Indicator) -> void:
	enter_counter += 1
	indicator.enter_id = enter_counter
	active_indicators.append(indicator)
	update_active()


func unregister(indicator: Indicator) -> void:
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

	active_indicators.sort_custom(func(a: Indicator, b: Indicator) -> bool:
		var da := a.distance_to_player()
		var db := b.distance_to_player()

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
