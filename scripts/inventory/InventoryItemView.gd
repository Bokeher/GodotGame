extends Control
class_name InventoryItemView

signal pressed(item: ItemData)
signal hovered(item: ItemData)
signal hover_exited()

@export var item: ItemData
@export var count: int

func setup(item_: ItemData, count_: int) -> void:
	item = item_
	count = count_
	
	$SlotTexture.texture_normal = item.texture
	$Count.visible = count > 1
	$Count.text = str(count)

func update_count(count_: int) -> void:
	count = count_
	$Count.visible = count > 1
	$Count.text = str(count)

func update_selection(is_selected: bool) -> void:
	$Background.color = Enums.get_background_color(is_selected)

func _on_slot_texture_pressed() -> void:
	pressed.emit(item)

func _on_mouse_entered() -> void:
	$Border.color = Enums.get_border_color(true)
	hovered.emit(item)

func _on_mouse_exited() -> void:
	$Border.color = Enums.get_border_color(false)
	hover_exited.emit()
