extends Control

func ItemPopup(parent: Rect2i, text: String, description: String) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var correction = null
	var padding = 4
	
	if(mouse_position.x <= get_viewport_rect().size.x / 2):
		correction = Vector2i(parent.size.x + padding, 0)
	else:
		correction = -Vector2i(%ItemPopup.size.x + padding, 0)
	
	%PopupTitle.text = text
	%PopupDescription.text = description

	# TODO: remove this offset
	var offset = Vector2i(715, 35)
	
	%ItemPopup.popup(Rect2i(parent.position + correction, %ItemPopup.size))

func HideItemPopup() -> void:
	%ItemPopup.hide()
