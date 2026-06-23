extends Control

@export var weather_index: int = 1

@onready var image: Sprite2D = $Image

func _ready() -> void:
	image.texture = load("res://assets/art/ui/weather-sheet.png")
	image.hframes = 3
	image.vframes = 1
	DaytimeClock.time_changed.connect(_on_time_changed)
	_update_weather_from_time(DaytimeClock.current_hour)

func set_weather(index: int) -> void:
	weather_index = index
	image.frame = clamp(index - 1, 0, 2)

func _update_weather_from_time(hour: int) -> void:
	if hour < 9:
		set_weather(1)
	elif hour >= 16:
		set_weather(3)
	else:
		set_weather(2)

func _on_time_changed(hour: int, _minute: int) -> void:
	_update_weather_from_time(hour)
