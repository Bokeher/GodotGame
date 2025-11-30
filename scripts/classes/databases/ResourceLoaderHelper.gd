extends Object
class_name ResourceLoaderHelper # Helper since godot alrdy has ResourceLoader

static func load_folder_to_dict(path: String, key_property := "id") -> Dictionary:
	var result: Dictionary = {}
	var dir := DirAccess.open(path)
	
	if dir == null:
		push_error("Can't open directory: %s" % path)
		return result
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		_process_file(path, file_name, key_property, result)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return result

static func _process_file(base_path: String, file_name: String, key_property: String, result: Dictionary) -> void:
	# Directory
	if file_name.ends_with("/") or file_name.ends_with("\\"):
		return
	
	# Not resource
	if not (file_name.ends_with(".tres") or file_name.ends_with(".res")):
		return
	
	var full_path := base_path.path_join(file_name)
	var res := load(full_path)
	
	if res == null:
		push_error("Failed to load: %s" % full_path)
		return
	
	if not res.get(key_property):
		push_error("Resource %s missing '%s'" % [full_path, key_property])
		return

	result[res.get(key_property)] = res
