extends Control

var skill_level = 0

var skill: Skill

func _ready():
	var id = $".".get_meta("id")
	
	skill = Global._skills[id - 1]
	
	update_level_label()

func _on_texture_button_mouse_entered():
	SkillPopup.show_skill_popup(skill.name, skill.description, skill_level)

func _on_texture_button_mouse_exited():
	SkillPopup.hide_skill_popup()

func _on_texture_button_pressed():
	level_up_skill()

func level_up_skill():
	if(skill_level >= skill.max_level):
		return
	
	skill_level += 1
	update_level_label()

func update_level_label():
	$SkillLevelLabel.text = str(skill_level) + " / " + str(skill.max_level)
