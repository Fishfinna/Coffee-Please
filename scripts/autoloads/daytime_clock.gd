extends Node

signal time_changed(hour: int, minute: int)
signal day_changed(day: int, month: int, year: int)
signal day_ended

const START_YEAR: int = 2025
const START_MONTH: int = 5
const START_DAY: int = 1
const START_DAY_OF_WEEK: int = 4

const DAY_START_HOUR := 6
const DAY_END_HOUR   := 18

const TOTAL_MINUTES := (DAY_END_HOUR - DAY_START_HOUR) * 60

var current_hour   : int = DAY_START_HOUR
var current_minute : int = 0
var current_day    : int = START_DAY
var current_month  : int = START_MONTH
var current_year   : int = START_YEAR
var current_day_of_week: int = START_DAY_OF_WEEK

var is_running     : bool = true

var _elapsed : float = 0.0
var speed: float = .05

# Days per month (non-leap-year; adjust if needed)
const DAYS_IN_MONTH := [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]


func _process(delta: float) -> void:
	if not is_running:
		return

	_elapsed += delta

	while _elapsed >= speed:
		_elapsed -= speed
		_advance_one_minute()


func _advance_one_minute() -> void:
	current_minute += 1

	if current_minute >= 60:
		current_minute = 0
		current_hour  += 1

	if current_hour >= DAY_END_HOUR:
		current_hour   = DAY_START_HOUR
		current_minute = 0
		emit_signal("day_ended")
		_advance_day()
		return

	emit_signal("time_changed", current_hour, current_minute)

func get_day_of_week_string() -> String:
	const DAY_NAMES := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	return DAY_NAMES[current_day_of_week]

func _advance_day() -> void:
	current_day += 1
	current_day_of_week = (current_day_of_week + 1) % 7
	var max_days := _days_in_month(current_month, current_year)

	if current_day > max_days:
		current_day    = 1
		current_month += 1

	if current_month > 12:
		current_month = 1
		current_year += 1

	emit_signal("day_changed", current_day, current_month, current_year)
	emit_signal("time_changed", current_hour, current_minute)

func _days_in_month(month: int, year: int) -> int:
	if month == 2 and _is_leap_year(year):
		return 29
	return DAYS_IN_MONTH[month]


func _is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)


func get_time_string() -> String:
	var display_hour := current_hour % 12
	if display_hour == 0:
		display_hour = 12
	var suffix := "AM" if current_hour < 12 else "PM"
	return "%d:%02d %s" % [display_hour, current_minute, suffix]

func get_date_string() -> String:
	const DAY_NAMES := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	const MONTH_NAMES := [
		"", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
	]
	var suffix := "th"
	match current_day:
		1, 21, 31: suffix = "st"
		2, 22:     suffix = "nd"
		3, 23:     suffix = "rd"
	return "%s, %s %d%s" % [DAY_NAMES[current_day_of_week], MONTH_NAMES[current_month], current_day, suffix]
func get_day_progress() -> float:
	var elapsed_minutes := (current_hour - DAY_START_HOUR) * 60 + current_minute
	return float(elapsed_minutes) / float(TOTAL_MINUTES)
