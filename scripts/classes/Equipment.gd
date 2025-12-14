extends Object
class_name Equipment

enum Slot { RING, CHEST }

var slots: Dictionary = {
	Slot.RING: null,
	Slot.CHEST: null
}

func equip_item(slot: Slot, item: ItemData):
	slots[slot] = item

func unequip_item(slot: Slot):
	slots[slot] = null
