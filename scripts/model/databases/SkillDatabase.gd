extends GenericDatabase
#class_name SkillDatabase
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/skills/"
	_data_type = "Skill"

func get_by_id(id: int) -> SkillData:
	return super.get_by_id(id)

func get_all() -> Dictionary[int, SkillData]:
	var untyped_data: Dictionary = super.get_all()
	
	var results: Dictionary[int, SkillData] = {}
	for key: int in untyped_data:
		results[key] = untyped_data[key] as SkillData
	
	return results

func get_sorted(skills: Dictionary[int, SkillData]) -> Array[SkillData]:
	var sorted: Array[SkillData] = skills.values()
	
	sorted.sort_custom(func(a: SkillData, b: SkillData) -> bool:
		if a.grid_position[1] == b.grid_position[1]:
			return a.grid_position[0] < b.grid_position[0]
		return a.grid_position[1] < b.grid_position[1]
	)
	
	return sorted
