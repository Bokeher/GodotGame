extends Control

@onready var slot_id: int = $".".get_meta("id")
@onready var item_id: int = $".".get_meta("item_id")
@onready var item: ItemData = ItemDatabase.get_by_id(item_id)
@onready var EquipSlots: HBoxContainer = $"../../EquipSlots"
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")

func _ready() -> void:
	if item.id == Enums.UNEQUIP_INVENTORY_SLOT_ID:
		var slot_type: int = EquipSlots.get_child(Global.selected_equip_slot_id - 1).get_meta("slot_type")
		var texture_path: String = Enums.get_inventory_type_texture(slot_type)
		
		$SlotTexture.texture_normal = load(texture_path)
		set_count(0)
		return
	
	$SlotTexture.texture_normal = item.texture

func _on_slot_texture_pressed() -> void:
	var children = $"../../EquipSlots".get_children()
	var equipSlot = children[Global.selected_equip_slot_id - 1]
	equipSlot.change_item(item.id)

func set_count(count: int) -> void:
	$Count.visible = count > 1
	$Count.text = str(count)

func _on_slot_texture_mouse_entered() -> void:
	$Background.color = Enums.Colors["BG_FOCUS_HOVER"]
	$Border.color = Enums.Colors["BORDER_FOCUS_HOVER"]
	
	if item.id == Enums.UNEQUIP_INVENTORY_SLOT_ID:
		popup.popup("Empty slot", "Press here to unequip item")
		return
	
	popup.popup(item.name, item.description)


func _on_slot_texture_mouse_exited() -> void:
	$Background.color = Enums.Colors["BG_UNFOCUS_HOVER"]
	$Border.color = Enums.Colors["BORDER_UNFOCUS_HOVER"]
	
	if item_id == -1: return
	
	popup.hide_()
