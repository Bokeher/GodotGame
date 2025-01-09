extends Control

var skill: Skill

func _ready():
	var id = $".".get_meta("id")
	
	skill = Global._skills[id - 1]
	
	update_level_label()

func update_skill():
	skill = Global._skills[skill.id - 1]
	
	update_level_label()

func _on_texture_button_mouse_entered():
	SkillPopup.show_skill_popup(skill.name, skill.description, skill.level)

func _on_texture_button_mouse_exited():
	SkillPopup.hide_skill_popup()

func _on_texture_button_pressed():
	level_up_skill()

func level_up_skill():
	if(skill.level >= skill.max_level || Global.player_stats.skill_points <= 0):
		return
	
	skill.level += 1
	Global.player_stats.skill_points -= 1
	$"../../../../../SkillPointsAmount".update_skill_points()
	
	update_level_label()

func update_level_label():
	$SkillLevelLabel.text = str(skill.level) + " / " + str(skill.max_level)
