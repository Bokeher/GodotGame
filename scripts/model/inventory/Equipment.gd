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

var slots: Dictionary[EquipmentSlotId, ItemData] = {
	EquipmentSlotId.RING1: null,
	EquipmentSlotId.CHEST: null
}

func equip_item(item: ItemData):
	slots[item.type] = item

func unequip_item(type: EquipmentSlotId):
	slots[type] = null
