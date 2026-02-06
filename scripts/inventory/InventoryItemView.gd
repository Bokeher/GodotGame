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
