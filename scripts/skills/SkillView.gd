extends Control
class_name SkillView

@export var skill: SkillData

signal pressed(skill: SkillData)
signal hovered(skill: SkillData)
signal hover_exited()

func setup(skill_: SkillData) -> void:
	skill = skill_
	
	update_level_label(0)
	update_skill_image()

func _on_texture_button_mouse_entered() -> void:
	$Border.color = Enums.get_border_color(true)
	hovered.emit(skill)

func _on_texture_button_mouse_exited() -> void:
	$Border.color = Enums.get_border_color(false)
	hover_exited.emit()

func _on_texture_button_pressed() -> void:
	pressed.emit(skill)

func update_level_label(skill_level: int) -> void:
	$SkillLevelLabel.text = str(skill_level) + " / " + str(skill.max_level)

func update_skill_image() -> void:
	$SkillButton.texture_normal = skill.texture
