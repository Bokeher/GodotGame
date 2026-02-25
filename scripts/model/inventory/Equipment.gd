extends Object
class_name Equipment

signal item_equipped(slot: EquipmentSlotId, item: ItemData)
signal item_unequipped(slot: EquipmentSlotId)
signal equipment_changed(slot: EquipmentSlotId)

enum EquipmentSlotId {
	RING1,
	RING2,
	CHEST
}

var _slots: Dictionary[EquipmentSlotId, ItemData] = {
	EquipmentSlotId.RING1: null,
	EquipmentSlotId.RING2: null,
	EquipmentSlotId.CHEST: null
}

func get_item(slot: EquipmentSlotId) -> ItemData:
	return _slots.get(slot)

func equip_item(slot: EquipmentSlotId, item: ItemData) -> void:
	if _slots[slot] == item:
		return 
	
	_slots[slot] = item
	item_equipped.emit(slot, item)
	equipment_changed.emit(slot)

func unequip_item(slot: EquipmentSlotId) -> void:
	_slots[slot] = null
	item_unequipped.emit(slot)
	equipment_changed.emit(slot)

func get_slots() -> Dictionary[EquipmentSlotId, ItemData]:
	return _slots

static func slot_accepts_item(slot: EquipmentSlotId, item_type: ItemData.ItemType) -> bool:
	match slot:
		EquipmentSlotId.RING1, EquipmentSlotId.RING2:
			return item_type == ItemData.ItemType.RING
		EquipmentSlotId.CHEST:
			return item_type == ItemData.ItemType.CHEST
	return false

static func get_item_type_for_slot(slot: EquipmentSlotId) -> ItemData.ItemType:
	match slot:
		EquipmentSlotId.RING1, EquipmentSlotId.RING2:
			return ItemData.ItemType.RING
		EquipmentSlotId.CHEST:
			return ItemData.ItemType.CHEST
	
	return ItemData.ItemType.NONE
