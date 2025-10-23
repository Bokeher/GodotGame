class_name LuckswornClass

# GAMBLER'S FATE
const GAMBLERS_FATE_PER_STACK_DAMAGE_INCREASE: float = 0.2
const GAMBLERS_FATE_HIT_CHANCE_PENALTY: float = 0.16
var curr_gamblers_fate_stacks: int = 0

# EXTREME LUCK
const EXTREME_LUCK_STACK_REQUIREMENT: int = 5
const EXTREME_LUCK_DAMAGE_MULTIPLIER: float = 2.0

# GUARANTEED WIN
const GUARANTEED_WIN_HIT_REQUIREMENTS_VALUES: Array[int] = [0, 9, 8, 7, 6, 5]
const GUARANTEED_WIN_DAMAGE_INCREASE: float = 0.25
var curr_guarateed_win_stacks: int = 0

func get_guaranteed_win_damage_mult() -> float:
	return 1 + GUARANTEED_WIN_DAMAGE_INCREASE

func should_guaranteed_win_proc() -> bool:
	return curr_guarateed_win_stacks == 0

## Return true on stack reset else false
func increase_guaranteed_win() -> bool:
	var guaranteed_win_level = Global.skills[Enums.LuckswornSkillIds.GUARANTEED_WIN - 1].level
	if guaranteed_win_level == 0:
		return false
	
	var stacks_to_proc: int = GUARANTEED_WIN_HIT_REQUIREMENTS_VALUES[guaranteed_win_level]
	
	# Increase by 1 and reset if on max stack
	curr_guarateed_win_stacks = wrapi(curr_guarateed_win_stacks + 1, 0, stacks_to_proc)
	
	return curr_guarateed_win_stacks == 0

func check_extreme_luck() -> bool:
	return curr_gamblers_fate_stacks >= EXTREME_LUCK_STACK_REQUIREMENT

func get_extreme_luck_damage_multiplier() -> float:
	return EXTREME_LUCK_DAMAGE_MULTIPLIER

func increase_gamblers_fate() -> void:
	curr_gamblers_fate_stacks += 1

func get_gamblers_fate_hit_chance_multiplier() -> float:
	return 1 - GAMBLERS_FATE_HIT_CHANCE_PENALTY

func reset_gamblers_fate() -> void:
	curr_gamblers_fate_stacks = 0

func get_gamblers_fate_damage_multiplier() -> float:
	# TODO: Decide if this should be additive or multiplicitve
	return 1 + curr_gamblers_fate_stacks * GAMBLERS_FATE_PER_STACK_DAMAGE_INCREASE
