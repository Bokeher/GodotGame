extends Button

func _pressed():
	$"../..".upgrade(10, 1)

func _on_mouse_entered():
	Popups.ItemPopup(Rect2i(Vector2i(global_position), Vector2i(size)), "Title")

func _on_mouse_exited():
	Popups.HideItemPopup()
