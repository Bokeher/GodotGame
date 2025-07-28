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

enum ItemIds {
	RING_OF_MINOR_DAMAGE = 22,
	RING_OF_DAMAGE = 23,
	RING_OF_MAJOR_DAMAGE = 24,
	LEATHER_JACKET = 25
}

enum WarriorSkillIds {
	HEAVY_BLOW = 1,
	OVERKILL = 2,
	BERSERK = 3,
	BLOODRAGE = 4,
	ADRENALINE = 5
}

enum UmbralReaverSkillIds {
	POISONED_BLADE = 1,
	MIRAGE = 2,
	ECHO_OF_AGONY = 3,
	AMBUSH = 4,
	SHADOW_COUNTER = 5
}

enum LuckswornSkillIds {
	GAMBLERS_FATE = 1,
	LUCKY_STRIKE = 2,
	SECOND_CHANCE = 3,
	GUARANTEED_WIN = 4,
	HIGH_ROLLER = 5
}

enum KenseiSkillIds {
	SWORDS_PATH = 1,
	MASTERS_TEMPO = 2,
	SWORDMASTERS_INSTINCT = 3,
	FLAWLESS_PRECISION = 4,
	KENSEIS_BURDEN = 5
}

const Colors := {
	"BG_FOCUS_HOVER": Color(0.30, 0.30, 0.30),
	"BORDER_FOCUS_HOVER": Color(0.60, 0.60, 0.60),
	"BG_UNFOCUS_HOVER": Color(0.21, 0.21, 0.21),
	"BORDER_UNFOCUS_HOVER": Color(0.30, 0.30, 0.30),
}

const UNKNOWN_PNG_PATH: String = "res://assets/sprites/classes/unknown.png"

# Dir paths
const CLASS_TEXTURES_DIR_PATH: String = "res://assets/sprites/classes/"
const INVENTORY_TEXTURES_DIR_PATH: String = "res://assets/sprites/items/slots/"
const CLASSES_DIR_PATH: String = "res://assets/jsons/classes/"

const CLASS_TEXTURES := {
	Classes.WARRIOR: CLASS_TEXTURES_DIR_PATH + "warrior.png",
	Classes.UMBRAL_REAVER: CLASS_TEXTURES_DIR_PATH + "umbral_reaver.png",
	Classes.LUCKSWORN: CLASS_TEXTURES_DIR_PATH + "lucksworn.png",
	Classes.KENSEI: CLASS_TEXTURES_DIR_PATH + "kensei.png"
}

const INVENTORY_TEXTURES := {
	InventoryType.ARTIFACT: INVENTORY_TEXTURES_DIR_PATH + "artifact_slot.png",
	InventoryType.CHEST: INVENTORY_TEXTURES_DIR_PATH + "chest_slot.png"
}

const CLASS_JSON_PATH := {
	Classes.WARRIOR: CLASSES_DIR_PATH + "warrior.json",
	Classes.UMBRAL_REAVER: CLASSES_DIR_PATH + "umbral_reaver.json",
	Classes.LUCKSWORN: CLASSES_DIR_PATH + "lucksworn.json",
	Classes.KENSEI: CLASSES_DIR_PATH + "kensei.json",
}

func get_class_json_path(class_type: int) -> String:
	return CLASS_JSON_PATH.get(class_type, null)

func get_inventory_type_texture(slot_type: int) -> String:
	return INVENTORY_TEXTURES.get(slot_type, UNKNOWN_PNG_PATH)

func get_class_texture(class_type: int) -> String:
	return CLASS_TEXTURES.get(class_type, UNKNOWN_PNG_PATH)
