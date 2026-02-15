extends Resource
class_name SaveManager

var save_dir: String = "user://saves"
var default_file: String = "scene_data.tres"

func create_directory(path: String) -> void:
	if DirAccess.dir_exists_absolute(path):
		return

	var err := DirAccess.make_dir_recursive_absolute(path)
	if err != OK:
		push_error("Failed to create directory: %s (err %s)" % [path, err])

func list_saves() -> Array[Dictionary]:
	var saves: Array[Dictionary] = []

	if not DirAccess.dir_exists_absolute(save_dir):
		return saves

	var dir := DirAccess.open(save_dir)
	if dir == null:
		return saves

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			var full_path := save_dir.path_join(file_name)
			if full_path.get_extension() == "tres":
				var modified_unix := FileAccess.get_modified_time(full_path)
				var modified_time := Time.get_datetime_string_from_unix_time(modified_unix)
				saves.append({
					"file": file_name,
					"modified": modified_time
				})
		file_name = dir.get_next()

	dir.list_dir_end()
	return saves


func save_game(player: Node2D, filename: String = default_file) -> void:
	create_directory(save_dir)
	var full_path := save_dir.path_join(filename)

	var data := SceneData.new()
	if player:
		data.player_position = player.global_position

	var err := ResourceSaver.save(data, full_path)
	if err != OK:
		push_error("Save failed: %s" % err)
	else:
		print("Saved to", full_path)

func load_game(filename: String = default_file) -> SceneData:
	var full_path := save_dir.path_join(filename)
	if not FileAccess.file_exists(full_path):
		return null
	return ResourceLoader.load(full_path) as SceneData
