extends Control

@onready var master: HSlider = $Master
@onready var music: HSlider = $Music
@onready var effects: HSlider = $Effects
@onready var fullscreen_toggle: CheckButton = $fullscreen

signal redirect_back()

var music_bus_index: int
var fx_bus_index: int

func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index("Music")
	fx_bus_index = AudioServer.get_bus_index("FX")

	master.value = Settings.get_setting("master_volume")
	music.value = Settings.get_setting("music_volume")
	effects.value = Settings.get_setting("effects_volume")
	fullscreen_toggle.button_pressed = Settings.get_setting("fullscreen")

	Settings.fullscreen_changed.connect(_on_fullscreen_changed)

	music.value_changed.connect(_on_music_value_changed)
	effects.value_changed.connect(_on_effects_value_changed)

func _on_h_slider_value_changed(value: float) -> void:
	Settings.update_setting("master_volume", value)

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus_index, value)
	Settings.update_setting("music_volume", value)

func _on_effects_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(fx_bus_index, value)
	Settings.update_setting("effects_volume", value)

func _on_check_button_toggled(toggled_on: bool) -> void:
	Settings.update_setting("fullscreen", toggled_on)

func _on_fullscreen_changed(value: bool) -> void:
	if fullscreen_toggle.button_pressed != value:
		fullscreen_toggle.button_pressed = value

func _on_back_pressed() -> void:
	emit_signal("redirect_back")
