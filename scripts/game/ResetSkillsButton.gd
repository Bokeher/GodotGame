extends Button

func _pressed():
	for skill in Global._skills:
		Global.player_stats.skill_points += skill.level
		skill.level = 0
	
	$"../SkillPointsAmount".update_skill_points()
	#TODO: update all levels on all skills in skill tree
