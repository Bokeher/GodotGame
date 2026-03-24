extends Node

const UNEQUIP_INVENTORY_SLOT_ID: int = -1

enum CharacterClass {
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
	ADRENALINE = 5,
	IRON_SKIN = 6,
	DIAMOND_SKIN = 7,
	MIGHTY_BLOW = 8
}

enum UmbralReaverSkillIds {
	POISONED_BLADE = 1,
	MIRAGE = 2,
	ECHO_OF_AGONY = 3,
	AMBUSH = 4,
	SHADOW_COUNTER = 5,
	SHARP_EDGE = 6,
	CRIT_CHANCE_I = 7,
	IMPROVED_AMBUSH = 8,
	CRIT_CHANCE_II = 9,
	PRECISE_COUNTER = 10,
	INSIDIOUS_KILLER = 11,
	SHADOW = 12,
	SWIFT_SLASH = 13,
	DOT_COUNTER = 14,
	CRIT_CHANCE_III = 15
}

enum LuckswornSkillIds {
	GAMBLERS_FATE = 1,
	LUCKY_STRIKE = 2,
	SWORN_DICE = 3,
	GUARANTEED_WIN = 4,
	HIGH_ROLLER = 5,
	LUCKIER_STRIKE = 6,
	BAD_LUCK = 7,
	EXTREME_LUCK = 8,
	HIT_CHANCE_I = 9,
	HIT_CHANCE_II = 10
}

enum KenseiSkillIds {
	SWORDS_PATH = 1,
	MASTERS_TEMPO = 2,
	SWORDMASTERS_INSTINCT = 3,
	FLAWLESS_PRECISION = 4,
	IMPROVED_INSTINCT = 5,
	CLEAN_CUT = 6,
	PATIENCE = 7,
	DULLED_INSTINCT = 8,
	SHARP_EDGE = 9,
	IMPROVED_TEMPO = 10,
	EXQUISIT_TEMPO = 11
}

const Colors := {
	"BG_FOCUS_HOVER": Color(0.30, 0.30, 0.30),
	"BORDER_FOCUS_HOVER": Color(0.60, 0.60, 0.60),
	"BG_UNFOCUS_HOVER": Color(0.21, 0.21, 0.21),
	"BORDER_UNFOCUS_HOVER": Color(0.30, 0.30, 0.30),
}

const ColorsHex := {
	"SKILL_DESCRIPTION_MAIN": "#FFD700",
	"SKILL_DESCRIPTION_SUB": "#D1B200"
}

const UNKNOWN_PNG_PATH: String = "res://assets/sprites/unknown.png"

# Dir paths
const CLASS_TEXTURES_DIR_PATH: String = "res://assets/sprites/classes/"
const EQUIPMENT_SLOT_ID_TEXTURES_DIR_PATH: String = "res://assets/sprites/items/slots/"
const CLASSES_DIR_PATH: String = "res://assets/jsons/classes/"

const CLASS_TEXTURES := {
	CharacterClass.WARRIOR: CLASS_TEXTURES_DIR_PATH + "warrior.png",
	CharacterClass.UMBRAL_REAVER: CLASS_TEXTURES_DIR_PATH + "umbral_reaver.png",
	CharacterClass.LUCKSWORN: CLASS_TEXTURES_DIR_PATH + "lucksworn.png",
	CharacterClass.KENSEI: CLASS_TEXTURES_DIR_PATH + "kensei.png"
}

const EQUIPMENT_SLOT_ID_TEXTURES := {
	Equipment.EquipmentSlotId.RING1: EQUIPMENT_SLOT_ID_TEXTURES_DIR_PATH + "artifact_slot.png",
	Equipment.EquipmentSlotId.RING2: EQUIPMENT_SLOT_ID_TEXTURES_DIR_PATH + "artifact_slot.png",
	Equipment.EquipmentSlotId.CHEST: EQUIPMENT_SLOT_ID_TEXTURES_DIR_PATH + "chest_slot.png"
}

const CLASS_JSON_PATH := {
	CharacterClass.WARRIOR: CLASSES_DIR_PATH + "warrior.json",
	CharacterClass.UMBRAL_REAVER: CLASSES_DIR_PATH + "umbral_reaver.json",
	CharacterClass.LUCKSWORN: CLASSES_DIR_PATH + "lucksworn.json",
	CharacterClass.KENSEI: CLASSES_DIR_PATH + "kensei.json",
}

func get_class_json_path(class_type: int) -> String:
	return CLASS_JSON_PATH.get(class_type, null)

func get_equipment_slot_id_texture(equipment_slot_id: Equipment.EquipmentSlotId) -> String:
	return EQUIPMENT_SLOT_ID_TEXTURES.get(equipment_slot_id, UNKNOWN_PNG_PATH)

func get_class_texture(class_type: int) -> String:
	return CLASS_TEXTURES.get(class_type, UNKNOWN_PNG_PATH)

func get_background_color(is_active: bool) -> Color:
	if is_active:
		return Colors["BG_FOCUS_HOVER"]
	return Colors["BG_UNFOCUS_HOVER"]

func get_border_color(is_active: bool) -> Color:
	if is_active:
		return Colors["BORDER_FOCUS_HOVER"]
	return Colors["BORDER_UNFOCUS_HOVER"]
