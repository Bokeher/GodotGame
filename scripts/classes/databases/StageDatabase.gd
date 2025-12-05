extends GenericDatabase
#class_name StageDatabase 
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/stages/"
	_data_type = "Stage"

func get_by_id(id: int) -> StageData:
	return super.get_by_id(id)
