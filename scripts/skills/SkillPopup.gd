extends Control

func show_skill_popup(skill: Skill) -> void:
	%PopupTitle.text = skill.name
	%PopupDescription.text = skill.description
	%PopupSkillLevel.text = "Level " + str(skill.level) + " / " + str(skill.max_level)

	var popup_position = Global.MAIN_TAB_CONTAINER_POSITION + Vector2i(-115, 31) # +30 on y is 1 pixel off

	%SkillPopup.popup(Rect2i(popup_position, %SkillPopup.size))

func hide_skill_popup() -> void:
	%SkillPopup.hide()
