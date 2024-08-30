extends Button

func _pressed():
	$"../..".upgrade(10, 1)

func _on_mouse_entered():
	Popups.ItemPopup(
		Rect2i(Vector2i(global_position), 
		Vector2i(size)), 
		"Upgrade your weapon", 
		"+1 Damage \n-10 Gold"
	)

func _on_mouse_exited():
	Popups.HideItemPopup()
