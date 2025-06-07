extends Node

enum Classes {
	WARRIOR = 0,
	UMBRAL_REAVER = 1,
	LUCKSWORN = 2,
	KENSEI = 3
}

enum InventoryType {
	NONE = 0,
	ARTIFACT = 1,
	CHEST = 2
}

const CLASS_TEXTURES := {
	Classes.WARRIOR: "res://assets/sprites/classes/warrior.png",
	Classes.UMBRAL_REAVER: "res://assets/sprites/classes/umral_reaver.png",
	Classes.LUCKSWORN: "res://assets/sprites/classes/lucksworn.png",
	Classes.KENSEI: "res://assets/sprites/classes/kensei.png"
}

const INVENTORY_TEXTURES := {
	InventoryType.ARTIFACT: "res://assets/sprites/items/slots/artifact_slot.png",
	InventoryType.CHEST: "res://assets/sprites/items/slots/chest_slot.png"
}

const CLASSES_DIR_PATH: String = "res://assets/jsons/classes/"
const CLASS_JSON_PATH := {
	Classes.WARRIOR: CLASSES_DIR_PATH + "warrior.json",
	Classes.UMBRAL_REAVER: CLASSES_DIR_PATH + "umbral_reaver.json",
	Classes.LUCKSWORN: CLASSES_DIR_PATH + "lucksworn.json",
	Classes.KENSEI: CLASSES_DIR_PATH + "kensei.json",
}

func get_class_json_path(class_type: int) -> String:
	return CLASS_JSON_PATH.get(class_type, null)

func get_inventory_type_texture(slot_type: int) -> String:
	return INVENTORY_TEXTURES.get(slot_type, "res://assets/sprites/unknown.png")

func get_class_texture(class_type: int) -> String:
	return CLASS_TEXTURES.get(class_type, "res://assets/sprites/classes/unknown.png")
