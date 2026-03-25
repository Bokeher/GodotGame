extends GenericDatabase
#class_name CharacterClassDatabase 
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/character_classes/"
	_data_type = "CharacterClass"

func get_by_id(id: int) -> CharacterClassData:
	return super.get_by_id(id)
