extends Control

@onready var slider: HSlider = $HSlider
@onready var fullscreen_toggle: CheckButton = $CheckButton

func _ready() -> void:
	slider.value = Settings.get_setting("master_volume")
	fullscreen_toggle.button_pressed = Settings.get_setting("fullscreen")

	Settings.fullscreen_changed.connect(_on_fullscreen_changed)

func _on_h_slider_value_changed(value: float) -> void:
	Settings.update_setting("master_volume", value)

func _on_check_button_toggled(toggled_on: bool) -> void:
	Settings.update_setting("fullscreen", toggled_on)

func _on_fullscreen_changed(value: bool) -> void:
	if fullscreen_toggle.button_pressed != value:
		fullscreen_toggle.button_pressed = value
