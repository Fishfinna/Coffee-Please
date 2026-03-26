# settings_autoload.gd
extends Node

const SETTINGS_PATH := "user://settings.tres"

var master_volume: float = 1.0
var fullscreen: bool = false
var resolution: Vector2i = Vector2i(1280, 720)

func _ready() -> void:
	_load_from_disk()
	apply_settings()

func update_setting(key: String, value) -> bool:
	if not key in ["master_volume", "fullscreen", "resolution"]:
		push_warning("Settings: unknown key '%s'" % key)
		return false
	set(key, value)
	save_settings()
	apply_settings()
	return true

func get_setting(key: String):
	return get(key)

func apply_settings() -> void:
	_apply_audio()
	_apply_display()

func _apply_audio() -> void:
	var bus := AudioServer.get_bus_index("Master")
	if bus == -1:
		return
	AudioServer.set_bus_volume_db(bus, linear_to_db(clamp(master_volume, 0.0, 1.0)))

func _apply_display() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
	if not fullscreen:
		DisplayServer.window_set_size(resolution)

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("settings", "master_volume", master_volume)
	config.set_value("settings", "fullscreen", fullscreen)
	config.set_value("settings", "resolution", resolution)
	config.save(SETTINGS_PATH)

func _load_from_disk() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		master_volume = config.get_value("settings", "master_volume", 1.0)
		fullscreen = config.get_value("settings", "fullscreen", false)
		resolution = config.get_value("settings", "resolution", Vector2i(1280, 720))
	else:
		save_settings()
