extends Node
class_name GenericDatabase

var _data: Dictionary = {}
var _dir_path: String
var _data_type: String

func _ready() -> void:
	read()

func read() -> void:
	if _dir_path == "":
		push_error("No dir path set for database: %s" % _data_type)
		return
	
	_data = ResourceLoaderHelper.load_folder_to_dict(_dir_path)

func get_by_id(id: int) -> Resource:
	var res: Resource = _data.get(id)
	
	if res == null:
		print("Id not found")
	
	return res

func get_all() -> Dictionary:
	return _data
