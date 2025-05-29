extends Node

enum Classes {
	WARRIOR,
	UMBRAL_REAVER,
	LUCKSWORN,
	KENSEI
}

enum InventoryType {
	NONE = 0,
	ARTIFACT = 1,
	CHEST = 2
}

const INVENTORY_TEXTURES := {
	InventoryType.ARTIFACT: "res://assets/sprites/items/slots/artifact_slot.png",
	InventoryType.CHEST: "res://assets/sprites/items/slots/chest_slot.png"
}

func get_inventory_type_texture(slot_type: int) -> String:
	return INVENTORY_TEXTURES.get(slot_type, "res://assets/sprites/unknown.png")
