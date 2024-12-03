extends Control

func ItemPopup(parent: Rect2i, text: String, description: String) -> void:
	var mouse_position = get_viewport().get_mouse_position()

	%PopupTitle.text = text
	%PopupDescription.text = description

	# TODO: somehow make this appear to the left of the $MainTabContainer without this hardcoded
	var offset = Vector2i(455, 30)

	%ItemPopup.popup(Rect2i(offset, %ItemPopup.size))

func HideItemPopup() -> void:
	%ItemPopup.hide()
