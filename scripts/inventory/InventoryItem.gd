extends Control

@onready var slot_id: int = $".".get_meta("id")
@onready var item_id: int = $".".get_meta("item_id")
@onready var item: Item = Global.items[item_id - 1]
@onready var EquipSlots: HBoxContainer = $"../../EquipSlots"

func _ready() -> void:
	# If this is empty slot used for unequipping
	if item_id == -1:
		var slot_type: int = EquipSlots.get_child(Global.selected_equip_slot_id - 1).get_meta("slot_type")
		var texture_path: String = Enums.get_inventory_type_texture(slot_type)
		
		$SlotTexture.texture_normal = load(texture_path)
		set_count(0)
		return
	
	$SlotTexture.texture_normal = load(item.image_path)

func _on_slot_texture_pressed() -> void:
	var children = $"../../EquipSlots".get_children()
	var equipSlot = children[Global.selected_equip_slot_id - 1]
	equipSlot.change_item(item_id)

func set_count(count: int) -> void:
	$Count.visible = count > 1
	$Count.text = str(count)
