extends GenericDatabase
#class_name EnemyDatabase 
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/enemies/"
	_data_type = "Enemy"

func get_by_id(id: int) -> EnemyData:
	return super.get_by_id(id)
