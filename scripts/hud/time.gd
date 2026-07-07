extends Control

@onready var date_label = $texts/date/label
@onready var time_label = $texts/time/label

func _ready() -> void:
	DaytimeClock.time_changed.connect(_on_time_changed)
	DaytimeClock.day_changed.connect(_on_day_changed)
	DaytimeClock.day_ended.connect(_on_day_ended)
	_refresh_display()

func _on_time_changed(_hour: int, _minute: int) -> void:
	_refresh_display()

func _on_day_changed(_day: int, _month: int, _year: int) -> void:
	_refresh_display()

func _on_day_ended() -> void:
	print("Day ended! Progress: ", DaytimeClock.get_day_progress())

func _refresh_display() -> void:
	time_label.text = DaytimeClock.get_time_string()
	date_label.text = DaytimeClock.get_date_string()
