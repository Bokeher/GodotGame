extends GenericDatabase
#class_name SkillDatabase
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/skills/"
	_data_type = "Skill"

func get_by_id(id: int) -> SkillData:
	return super.get_by_id(id)
