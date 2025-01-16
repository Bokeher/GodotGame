extends Control

func show_skill_popup(text: String, description: String, skill_level: int) -> void:
	%PopupTitle.text = text
	%PopupDescription.text = description
	%PopupSkillLevel.text = "Level " + str(skill_level)

	var popup_position = Global.MAIN_TAB_CONTAINER_POSITION + Vector2i(-115, 31) # +30 on y is 1 pixel off

	%SkillPopup.popup(Rect2i(popup_position, %SkillPopup.size))

func hide_skill_popup() -> void:
	%SkillPopup.hide()
