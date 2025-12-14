extends Object
class_name ResourceLoaderHelper # Helper since godot alrdy has ResourceLoader

static func load_folder_to_dict(path: String, key_property := "id") -> Dictionary:
	var result: Dictionary = {}
	_scan_dir_recursive(path, key_property, result)
	return result

static func _scan_dir_recursive(path: String, key_property: String, result: Dictionary) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Can't open directory: %s" % path)
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
		
		var full_path := path.path_join(file_name)
		
		if dir.current_is_dir():
			_scan_dir_recursive(full_path, key_property, result)
		else:
			_process_file(path, file_name, key_property, result)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

static func _process_file(base_path: String, file_name: String, key_property: String, result: Dictionary) -> void:
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
