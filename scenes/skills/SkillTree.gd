extends Control

func _ready() -> void:
	update_skill_points()

func update_skill_points() -> void:
	var skillTreePanel = $"SubViewportContainer/SubViewport/SkillTreePanel"
	for skillNode in skillTreePanel.get_children():
		skillNode.update_skill()
	
	$SkillPointsAmount.text = "Skill points: " + str(Global.player_stats.skill_points)

func _on_reset_skills_button_pressed() -> void:
	for skill in Global.skills:
		Global.player_stats.skill_points += skill.level
		skill.level = 0
	
	update_skill_points()
