extends Control

@onready var slider: HSlider = $HSlider

func _ready() -> void:
	slider.value = Settings.get_setting("master_volume")
	
func _on_h_slider_value_changed(value: float) -> void:
	Settings.update_setting("master_volume", value)


func _on_check_button_toggled(toggled_on: bool) -> void:
	Settings.update_setting("fullscreen", toggled_on)
