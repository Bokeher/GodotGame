extends Control

@onready var item_id: int = $".".get_meta("item_id")
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")

func _on_panel_mouse_entered() -> void:
	var item = Global.items[item_id - 1]
	
	popup.popup(item.name, item.description)

func _on_panel_mouse_exited() -> void:
	popup.hide_()
