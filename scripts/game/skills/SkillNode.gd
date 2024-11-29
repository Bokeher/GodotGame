extends Control

var skill_name = "Skill name"
var skill_descritpion = "Skill descritpion"

func _on_texture_button_mouse_entered():
	Popups.ItemPopup(Rect2i(Vector2i(global_position), Vector2i(size)), skill_name, skill_descritpion)

func _on_texture_button_mouse_exited():
	Popups.HideItemPopup()
