extends Resource
class_name PlayerSkills

var _skill_levels_by_id: Dictionary[int, int] = {}
# <skill_id, level>

@export var skill_points: int

signal skill_level_changed(skill_data: SkillData, level: int)
signal skills_refunded()
signal skill_points_changed(skill_points: int)

func increase_skill_points(count: int) -> void:
	if count <= 0: 
		return
	
	skill_points += count
	skill_points_changed.emit(skill_points)

func get_level(skill_id: int) -> int:
	return _skill_levels_by_id.get(skill_id, 0)

func set_level(skill_id: int, level: int) -> void:
	var skill_data: SkillData = SkillDatabase.get_by_id(skill_id)
	
	var final_level: int = clampi(level, 0, skill_data.max_level)
	
	if get_level(skill_id) == final_level:
		return
	
	if final_level == 0:
		_skill_levels_by_id.erase(skill_id)
		skill_level_changed.emit(skill_data, 0)
		return
	
	_skill_levels_by_id[skill_id] = final_level
	skill_level_changed.emit(skill_data, final_level)

func can_level_up(skill_id: int) -> bool:
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

func refund_all_skills() -> void:
	var total_points: int = 0
	
	for skill_points_: int in _skill_levels_by_id.values():
		total_points += skill_points_
	
	_skill_levels_by_id.clear()
	
	skill_points += total_points
	skill_points_changed.emit(skill_points)
	skills_refunded.emit()

func level_up(skill_id: int) -> bool:
	if !can_level_up(skill_id):
		return false
	
	set_level(skill_id, get_level(skill_id) + 1)
	
	skill_points -= 1
	skill_points_changed.emit(skill_points)
	
	return true
