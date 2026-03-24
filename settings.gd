extends Resource

const SETTINGS_PATH := "user://settings.tres"

@export var master_volume: float = 1.0
@export var fullscreen: bool = false
@export var resolution: Vector2i = Vector2i(1280, 720)

func _init():
	_load_from_disk()
	apply_settings()

func get_settings() -> Dictionary:
	return {
		"master_volume": master_volume,
		"fullscreen": fullscreen,
		"resolution": resolution
	}

func get_setting(key_name: String):
	return get(key_name)

func load_settings(dict: Dictionary) -> void:
	for key in dict.keys():
		if get(key) != null:
			set(key, dict[key])

	save_settings()
	apply_settings()

func apply_settings() -> void:
	_apply_audio()
	_apply_display()

func _apply_audio() -> void:
	var bus := AudioServer.get_bus_index("Master")
	if bus == -1:
		return

	var volume = clamp(master_volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus, linear_to_db(volume))

func _apply_display() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN
		if fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
	)

	if not fullscreen:
		DisplayServer.window_set_size(resolution)

func save_settings() -> void:
	ResourceSaver.save(self, SETTINGS_PATH)

func _load_from_disk() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var loaded := ResourceLoader.load(SETTINGS_PATH)
		if loaded:
			master_volume = loaded.master_volume
			fullscreen = loaded.fullscreen
			resolution = loaded.resolution
	else:
		save_settings()
