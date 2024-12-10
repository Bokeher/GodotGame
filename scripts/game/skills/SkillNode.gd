extends Control

var skill_name = "Skill name"
var skill_descritpion = "Skill descritpion"
var skill_level = 0
var max_level = 5

func _ready():
	skill_name = $".".get_meta("skill_name")
	skill_descritpion = $".".get_meta("skill_descritpion")
	update_level_label()

func _on_texture_button_mouse_entered():
	Popups.SkillPopup(skill_name, skill_descritpion)

func _on_texture_button_mouse_exited():
	Popups.HideSkillPopup()

func _on_texture_button_pressed():
	level_up_skill()

func level_up_skill():
	if(skill_level >= max_level):
		return
	
	skill_level += 1
	update_level_label()

func update_level_label():
	$SkillLevelLabel.text = str(skill_level) + " / " + str(max_level)
