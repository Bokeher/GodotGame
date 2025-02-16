extends Button

func _pressed() -> void:
	for skill in Global.skills:
		Global.player_stats.skill_points += skill.level
		skill.level = 0
	
	$"../SkillPointsAmount".update_skill_points()
