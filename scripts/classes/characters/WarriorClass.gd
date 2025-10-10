class_name WarriorClass

var adrenalineStacks: int = 0
var ADRENALINE_DAMAGE_INCREASE_PER_LEVEL: float = 0.25
var ironskin_value: int = 1
var diamondskin_values: Array[float] = [0, 0.05, 0.05, 0.10]

func add_adrenaline_stack() -> void:
	var adrenaline: Skill = Global.skills[Enums.WarriorSkillIds.ADRENALINE - 1]
	
	if adrenaline.level == 0:
		return
	
	adrenalineStacks += 1

## Returns damage amount reduced by *Iron Skin*
func get_ironskin_damage_reduction() -> int:
	var iron_skin: Skill = Global.skills[Enums.WarriorSkillIds.IRON_SKIN - 1]
	if iron_skin.level == 0:
		return 0
	
	return ironskin_value

## Returns damage amount reduced by *Diamond Skin*
func get_diamondskin_damage_reduction(damage: int) -> int:
	var diamond_skin: Skill = Global.skills[Enums.WarriorSkillIds.DIAMOND_SKIN - 1]
	if diamond_skin.level == 0:
		return 0
	
	var value: float = diamondskin_values[diamond_skin.level]
	
	# Always round up
	var damage_reduce: int = ceil(float(damage) * value)
	
	return damage_reduce 

func get_adrenaline_damage_multiplier() -> float:
	var adrenaline: Skill = Global.skills[Enums.WarriorSkillIds.ADRENALINE - 1]
	
	if adrenaline.level == 0:
		return 1
	
	var bonus_multiplier: float = (adrenaline.level * ADRENALINE_DAMAGE_INCREASE_PER_LEVEL)
	
	return 1 + bonus_multiplier * adrenalineStacks
