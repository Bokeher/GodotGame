extends Control

@onready var popup_panel = $Popup
@onready var item_id = $".".get_meta("item_id")
@onready var pos = $".".get_global_rect().position

func _on_panel_mouse_entered() -> void:
	var item = Global.items[item_id - 1]
	$Popup/Panel/VBoxContainer/ItemName.text = item.name
	$Popup/Panel/VBoxContainer/Description.text = item.description
	popup_panel.popup(Rect2i(315, 31, 0, 0))

func _on_panel_mouse_exited() -> void:
	popup_panel.hide()
