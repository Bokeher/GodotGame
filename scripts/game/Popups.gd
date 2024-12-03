extends Control

func SkillPopup(text: String, description: String) -> void:
	%PopupTitle.text = text
	%PopupDescription.text = description

	# TODO: somehow make this appear to the left of the $MainTabContainer without this hardcoded
	var popup_position = Vector2i(455, 30)

	%SkillPopup.popup(Rect2i(popup_position, %SkillPopup.size))

func HideSkillPopup() -> void:
	%SkillPopup.hide()
