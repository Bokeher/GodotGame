extends Control

@onready var name_ = $Popup/Panel/VBoxContainer/Name
@onready var description = $Popup/Panel/VBoxContainer/Description

func popup(popup_name: String, popup_description: String) -> void:
	var rect = Rect2i(315, 31, 0, 0)
	
	name_.text = popup_name
	description.text = popup_description
	
	$Popup.popup(rect)

func hide_() -> void:
	$Popup.hide()
