extends Control

func ItemPopup(parent: Rect2i, text):
	var mouse_position = get_viewport().get_mouse_position()
	var correction = null
	var padding = 4
	
	if(mouse_position.x <= get_viewport_rect().size.x/2):
		correction = Vector2i(parent.size.x + padding, 0)
	else:
		correction = -Vector2i(%ItemPopup.size.x + padding, 0)
	
	%PopupTitle.text = text
	
	%ItemPopup.popup(Rect2i(parent.position + correction, %ItemPopup.size))

func HideItemPopup():
	%ItemPopup.hide()
