extends Control

@onready var popup_panel = $Popup
@onready var item_id = $".".get_meta("item_id")
@onready var pos = $".".get_global_rect().position

func _on_panel_mouse_entered() -> void:
	$Popup/Panel/ItemName.text = Global.items[item_id - 1].name
	popup_panel.popup(Rect2i(370, 32, 50, 50))

func _on_panel_mouse_exited() -> void:
	popup_panel.hide()
