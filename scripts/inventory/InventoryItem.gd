extends Control

@onready var slot_id: int = $".".get_meta("id")
@onready var item_id: int = $".".get_meta("item_id")
@onready var item: Item = Global.items[item_id - 1]

func _ready() -> void:
	$SlotTexture.texture_normal = load(item.image_path)

func _on_slot_texture_pressed() -> void:
	var children = $"../../../ArtifactsPanel/ArtifactSlots".get_children()
	var equipSlot = children[Global.selected_equip_slot_id - 1]
	equipSlot.change_item(item_id)

func set_count(count: int) -> void:
	$Count.visible = count > 1
	$Count.text = str(count)
