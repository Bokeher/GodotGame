extends Object
class_name PlayerSkills

var _skill_levels_by_id: Dictionary[int, int]
# <skill_id, level>

func get_level(skill_id: int) -> int:
	return _skill_levels_by_id.get(skill_id, 0)

func set_level(skill_id: int, level: int) -> void:
	_skill_levels_by_id[skill_id] = level
