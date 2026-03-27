extends GenericDatabase
#class_name CharacterClassDatabase 
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/character_classes/"
	_data_type = "CharacterClass"

func get_by_id(id: int) -> CharacterClassData:
	return super.get_by_id(id)

func get_by_char_class(class_type: Enums.CharacterClass) -> CharacterClassData:
	for char_class: CharacterClassData in get_all().values():
		if char_class.class_type == class_type:
			return char_class
	
	print("ERROR! This should never print! (Missing CharacterClassData in DB)")
	return null
