extends Object
class_name Equipment

var slots: Dictionary[ItemData.ItemType, ItemData] = {
	ItemData.ItemType.RING: null,
	ItemData.ItemType.CHEST: null
}

func equip_item(item: ItemData):
	slots[item.type] = item

func unequip_item(type: ItemData.ItemType):
	slots[type] = null
