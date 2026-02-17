extends Resource
class_name SaveManager

var save_dir: String = "user://saves"
var default_file: String = "scene_data.tres"
var max_saves = 20

#region Directory Helpers
func create_directory(path: String) -> void:
	if DirAccess.dir_exists_absolute(path):
		return

	var err := DirAccess.make_dir_recursive_absolute(path)
	if err != OK:
		push_error("Failed to create directory: %s (err %s)" % [path, err])
#endregion

# region List Saves
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
					"modified": modified_time,
					"modified_unix": modified_unix
				})
		file_name = dir.get_next()

	dir.list_dir_end()
	return saves
#endregion

#region Save Slot Naming
func get_next_save_filename() -> String:
	var saves := list_saves()
	var existing_numbers := []

	for save in saves:
		var name: String = save.file.get_basename()
		if name.begins_with("save_slot_"):
			var num_str := name.replace("save_slot_", "")
			var num := int(num_str)
			existing_numbers.append(num)

	for i in range(1, max_saves + 1):
		if i not in existing_numbers:
			return "save_slot_%d.tres" % i

	if saves.size() > 0:
		saves.sort_custom(func(a, b):
			return b.modified_unix - a.modified_unix
		)
		print("All %d save slots used, overwriting:" % max_saves, saves[0].file)
		return saves[0].file
	push_error("No available save slots and no saves found!")
	return ""
#endregion

#region Save / Load
func save_game(player: Node2D, filename: String = "") -> void:
	create_directory(save_dir)

	if filename == "":
		filename = get_next_save_filename()
	if filename == "":
		return

	var full_path := save_dir.path_join(filename)

	var data := SceneData.new()
	if player:
		data.player_position = player.global_position

	var err := ResourceSaver.save(data, full_path)
	if err != OK:
		push_error("Save failed: %s" % err)
	else:
		print("Saved to", full_path)


func load_game(filename: String = "") -> SceneData:
	if filename == "":
		var saves := list_saves()
		if saves.size() == 0:
			print("No saves found")
			return null

		saves.sort_custom(func(a, b):
			return b.modified_unix - a.modified_unix
		)
		filename = saves[0].file

	var full_path := save_dir.path_join(filename)
	if not FileAccess.file_exists(full_path):
		print("Save file not found:", full_path)
		return null

	return ResourceLoader.load(full_path) as SceneData
#endregion

#region Delete
func delete_save(filename: String) -> void:
	var full_path := save_dir.path_join(filename)

	if FileAccess.file_exists(full_path):
		var dir := DirAccess.open(save_dir)
		if dir:
			var err := dir.remove(filename)
			if err != OK:
				push_error("Failed to delete save: %s" % full_path)
			else:
				print("Deleted save:", filename)
		else:
			push_error("Could not open save directory: %s" % save_dir)
	else:
		print("File does not exist:", full_path)
#endregion
