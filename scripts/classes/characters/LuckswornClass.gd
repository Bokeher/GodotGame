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

# LUCKY STRIKE
const LUCKY_STRIKE_CHANCE_VALUES: Array[float] = [0, 0.01, 0.02, 0.03, 0.04, 0.05]
const LUCKY_STRIKE_DAMAGE_MULTIPLIER: float = 2.0
var lucky_strike_active: bool = false

# LUCKIER STRIKE
const LUCKIER_STRIKE_CHANCE_VALUES: Array[float] = [0, 0.001, 0.002, 0.003, 0.004, 0.005]
const LUCKIER_STRIKE_DAMAGE_MULTIPLIER: float = 4.0
var luckier_strike_active: bool = false

# SWORN DICE
var sworn_dice_dice_value: int = 0
const SWORN_DICE_NUMBER: int = 6

# BAD LUCK
var BAD_LUCK_DICE_NUMBER: int = 5
const BAD_LUCK_DAMAGE_DECREASE: float = 0.5
var bad_luck_active: bool = false

func check_bad_luck() -> bool:
	return bad_luck_active

func set_bad_luck(enemy_hit: bool = false) -> void:
	var bad_luck: Skill = Global.skills[Enums.LuckswornSkillIds.BAD_LUCK - 1]
	
	if bad_luck.level == 0:
		bad_luck_active = false
		return
	
	if !enemy_hit:
		bad_luck_active = sworn_dice_dice_value == BAD_LUCK_DICE_NUMBER
	else:
		bad_luck_active = false

func get_bad_luck_damage_multiplier() -> float:
	return 1 - BAD_LUCK_DAMAGE_DECREASE

func roll_sworn_dice() -> void:
	var sworn_dice: Skill = Global.skills[Enums.LuckswornSkillIds.SWORN_DICE - 1]
	
	if sworn_dice.level == 0:
		return
	
	sworn_dice_dice_value = randi_range(1, 6)
	print("Sworn dice: " + str(sworn_dice_dice_value))

func check_sworn_dice_save_throw() -> bool:
	return sworn_dice_dice_value == SWORN_DICE_NUMBER

func get_luckier_strike_damage_multiplier() -> float:
	return LUCKIER_STRIKE_DAMAGE_MULTIPLIER

func roll_luckier_strike() -> void:
	var luckier_strike: Skill = Global.skills[Enums.LuckswornSkillIds.LUCKIER_STRIKE - 1]
	
	if luckier_strike.level == 0:
		return
	
	var chance: float = LUCKIER_STRIKE_CHANCE_VALUES[luckier_strike.level]
	
	luckier_strike_active = randf() <= chance

func check_luckier_strike() -> bool:
	return luckier_strike_active

func get_lucky_strike_damage_multiplier() -> float:
	return LUCKY_STRIKE_DAMAGE_MULTIPLIER

func roll_lucky_strike() -> void:
	var lucky_strike: Skill = Global.skills[Enums.LuckswornSkillIds.LUCKY_STRIKE - 1]
	
	if lucky_strike.level == 0:
		return
	
	var chance: float = LUCKY_STRIKE_CHANCE_VALUES[lucky_strike.level]
	
	lucky_strike_active = randf() <= chance

func check_lucky_strike() -> bool:
	return lucky_strike_active

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
