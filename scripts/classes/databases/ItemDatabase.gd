extends GenericDatabase
#class_name ItemDatabase 
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/items/"
	_data_type = "Item"

func get_by_id(id: int) -> ItemData:
	return super.get_by_id(id)
