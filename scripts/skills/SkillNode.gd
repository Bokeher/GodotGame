extends Control
class_name SkillNode

@export var skill: SkillData
var _player_skills: PlayerSkills

signal pressed(skill: SkillData)
signal hovered(skill: SkillData)
signal hover_exited()

func setup(skill_: SkillData, player_skills_: PlayerSkills) -> void:
	skill = skill_
	_player_skills = player_skills_
	
	update_level_label()
	update_skill_image()

func _on_texture_button_mouse_entered() -> void:
	hovered.emit(skill)

func _on_texture_button_mouse_exited() -> void:
	hover_exited.emit(skill)

func _on_texture_button_pressed() -> void:
	pressed.emit(skill)

func update_level_label() -> void:
	var curr_level: int = _player_skills.get_level(skill.id)
	
	$SkillLevelLabel.text = str(curr_level) + " / " + str(skill.max_level)

func update_skill_image() -> void:
	$SkillButton.texture_normal = skill.texture
