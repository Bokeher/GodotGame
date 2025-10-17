class_name WarriorClass

const HEAVY_BLOW_BASE_DAMAGE_INCREASE: float = 0.5
const HEAVY_BLOW_BASE_ATTACK_SPEED_PENALTY: float = 0.25

var adrenalineStacks: int = 0
const ADRENALINE_DAMAGE_INCREASE_PER_LEVEL: float = 0.25

var ironskin_value: int = 1
var diamondskin_values: Array[float] = [0, 0.05, 0.05, 0.10]

const MIGHTY_BLOW_PENALTY_REDUCE: float = 0.05

const BERSERK_ATTACK_SPEED_VALUE: float = 0.25

var curr_overkill_damage: int = 0
const OVERKILL_VALUES: Array[float] = [0, 0.25, 0.50, 0.75, 1.00, 1.50]

func increase_overkill_damage(overkill_difference: int) -> void:
	if overkill_difference <= 0:
		return
	
	var overkill: Skill = Global.skills[Enums.WarriorSkillIds.OVERKILL - 1]
	if overkill.level == 0:
		return
	
	var damage_mult: float = OVERKILL_VALUES[overkill.level]
	
	curr_overkill_damage += round(float(overkill_difference) * damage_mult)

func add_adrenaline_stack() -> void:
	var adrenaline: Skill = Global.skills[Enums.WarriorSkillIds.ADRENALINE - 1]
	
	if adrenaline.level == 0:
		return
	
	adrenalineStacks += 1

func get_berserk_attack_speed_bonus() -> float:
	return BERSERK_ATTACK_SPEED_VALUE

## Returns penalty multiplier. Penalty is >1 because its interval_time so higher value means lower attack speed
func get_heavy_blow_attack_speed_penalty_multiplier() -> float:
	var heavy_blow: Skill = Global.skills[Enums.WarriorSkillIds.HEAVY_BLOW - 1]
	
	if heavy_blow.level == 0:
		return 1
	
	var mighty_blow: Skill = Global.skills[Enums.WarriorSkillIds.MIGHTY_BLOW - 1]
	
	if mighty_blow.level == 0:
		return 1 + HEAVY_BLOW_BASE_ATTACK_SPEED_PENALTY
	
	return 1 + HEAVY_BLOW_BASE_ATTACK_SPEED_PENALTY - MIGHTY_BLOW_PENALTY_REDUCE

func get_heavy_blow_attack_damage_multipier() -> float:
	return 1 + HEAVY_BLOW_BASE_DAMAGE_INCREASE

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
