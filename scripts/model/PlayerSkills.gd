extends Resource
class_name PlayerSkills

var _skill_levels_by_id: Dictionary[int, int] = {}
# <skill_id, level>

func get_level(skill_id: int) -> int:
	return _skill_levels_by_id.get(skill_id, 0)

func set_level(skill_id: int, level: int) -> void:
	var skill_data: SkillData = SkillDatabase.get_by_id(skill_id)
	
	var final_level: int = clampi(level, 0, skill_data.max_level)
	
	if final_level == 0:
		_skill_levels_by_id.erase(skill_id)
		return
	
	_skill_levels_by_id[skill_id] = final_level

func can_level_up(skill_id: int, skill_points: int) -> bool:
	if skill_points <= 0:
		return false
	
	var skill_data: SkillData = SkillDatabase.get_by_id(skill_id)
	if get_level(skill_id) >= skill_data.max_level:
		return false
	
	return meets_requirements(skill_data)

func meets_requirements(skill_data: SkillData) -> bool:
	for required_skill: SkillData in skill_data.requirements:		
		if get_level(required_skill.id) <= 0:
			return false
	
	return true

func refund_all_skills() -> int:
	var total_points: int = 0
	
	for skill_points: int in _skill_levels_by_id.values():
		total_points += skill_points
	
	_skill_levels_by_id.clear()
	
	return total_points
