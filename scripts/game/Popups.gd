extends Control

func ItemPopup(parent: Rect2i, text: String, description: String) -> void:
	var mouse_position = get_viewport().get_mouse_position()

	%PopupTitle.text = text
	%PopupDescription.text = description

	# TODO: remove this offset
	var offset = Vector2i(715, 35)
	
	%ItemPopup.popup(Rect2i(parent.position + offset, %ItemPopup.size))

func HideItemPopup() -> void:
	%ItemPopup.hide()
