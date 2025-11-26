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
var guaranteed_win_active: bool = false

# LUCKY STRIKE
const LUCKY_STRIKE_CHANCE_VALUES: Array[float] = [0, 0.01, 0.02, 0.03, 0.04, 0.05]
const LUCKY_STRIKE_DAMAGE_MULTIPLIER: float = 2.0
var lucky_strike_active: bool = false

# LUCKIER STRIKE
const LUCKIER_STRIKE_CHANCE_VALUES: Array[float] = [0, 0.001, 0.002, 0.003, 0.004, 0.005]
const LUCKIER_STRIKE_DAMAGE_MULTIPLIER: float = 4.0
var luckier_strike_active: bool = false

# SWORN DICE
const SWORN_DICE_DICE_NUMBER: int = 6
var sworn_dice_dice_value: int = 0

# BAD LUCK
var BAD_LUCK_DICE_NUMBER: int = 5
const BAD_LUCK_DAMAGE_DECREASE: float = 0.5
var bad_luck_active: bool = false

# HIT CHANCE I
var HIT_CHANCE_1_VALUES: Array[float] = [0, 0.005, 0.01]

# HIT CHANCE II
var HIT_CHANCE_2_VALUES: Array[float] = [0, 0.002, 0.004, 0.006, 0.008, 0.01]

func get_hit_chance() -> float:
	var chance: float = get_gamblers_fate_hit_chance_multiplier()
	
	chance += get_hit_chance_1_bonus()
	chance += get_hit_chance_2_bonus()
	
	return chance

func get_hit_chance_2_bonus() -> float:
	var hit_chance_2: Skill = Global.skills[Enums.LuckswornSkillIds.HIT_CHANCE_II - 1]
	
	return HIT_CHANCE_2_VALUES[hit_chance_2.level]

func get_hit_chance_1_bonus() -> float:
	var hit_chance_1: Skill = Global.skills[Enums.LuckswornSkillIds.HIT_CHANCE_I - 1]
	
	return HIT_CHANCE_1_VALUES[hit_chance_1.level]

func is_bad_luck_active() -> bool:
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
	if !is_bad_luck_active():
		return 1
	
	return 1 - BAD_LUCK_DAMAGE_DECREASE

func roll_sworn_dice() -> void:
	var sworn_dice: Skill = Global.skills[Enums.LuckswornSkillIds.SWORN_DICE - 1]
	
	if sworn_dice.level == 0:
		return
	
	sworn_dice_dice_value = randi_range(1, 6)
	
	var dice_node: AnimatedSprite2D = Global.get_node("/root/Game/LuckswornSpecific/SwornDice")
	
	dice_node.visible = true
	dice_node.frame = sworn_dice_dice_value - 1
	
	# Hide after 0.5s
	await Global.get_tree().create_timer(0.50).timeout
	dice_node.visible = false

func check_sworn_dice_save_throw() -> bool:
	return sworn_dice_dice_value == SWORN_DICE_DICE_NUMBER

func get_luckier_strike_damage_multiplier() -> float:
	if !is_luckier_strike_active():
		return 1
	
	return LUCKIER_STRIKE_DAMAGE_MULTIPLIER

func roll_luckier_strike() -> void:
	var luckier_strike: Skill = Global.skills[Enums.LuckswornSkillIds.LUCKIER_STRIKE - 1]
	
	if luckier_strike.level == 0:
		return
	
	var chance: float = LUCKIER_STRIKE_CHANCE_VALUES[luckier_strike.level]
	
	luckier_strike_active = randf() <= chance

func is_luckier_strike_active() -> bool:
	return luckier_strike_active

func get_lucky_strike_damage_multiplier() -> float:
	if !is_lucky_strike_active():
		return 1
	
	return LUCKY_STRIKE_DAMAGE_MULTIPLIER

func roll_lucky_strike() -> void:
	var lucky_strike: Skill = Global.skills[Enums.LuckswornSkillIds.LUCKY_STRIKE - 1]
	
	if lucky_strike.level == 0:
		return
	
	var chance: float = LUCKY_STRIKE_CHANCE_VALUES[lucky_strike.level]
	
	lucky_strike_active = randf() <= chance

func is_lucky_strike_active() -> bool:
	return lucky_strike_active

func get_guaranteed_win_damage_mult() -> float:
	if !is_guaranteed_win_active():
		return 1
	
	return 1 + GUARANTEED_WIN_DAMAGE_INCREASE

func is_guaranteed_win_active() -> bool:
	return guaranteed_win_active

## Return true on stack reset (proc) else false
func increase_guaranteed_win() -> bool:
	var guaranteed_win_level = Global.skills[Enums.LuckswornSkillIds.GUARANTEED_WIN - 1].level
	if guaranteed_win_level == 0:
		return false
	
	var stacks_to_proc: int = GUARANTEED_WIN_HIT_REQUIREMENTS_VALUES[guaranteed_win_level]
	
	# Increase by 1 and reset if on max stack
	curr_guarateed_win_stacks = wrapi(curr_guarateed_win_stacks + 1, 0, stacks_to_proc)
	
	guaranteed_win_active = curr_guarateed_win_stacks == 0
	
	return guaranteed_win_active

func is_extreme_luck_active() -> bool:
	return curr_gamblers_fate_stacks >= EXTREME_LUCK_STACK_REQUIREMENT

func get_extreme_luck_damage_multiplier() -> float:
	if !is_extreme_luck_active():
		return 1
	
	return EXTREME_LUCK_DAMAGE_MULTIPLIER

func increase_gamblers_fate() -> void:
	curr_gamblers_fate_stacks += 1

func get_gamblers_fate_hit_chance_multiplier() -> float:
	var gamblers_fate: Skill = Global.skills[Enums.LuckswornSkillIds.GAMBLERS_FATE - 1]
	
	if gamblers_fate.level == 0:
		return 1
	
	return 1 - GAMBLERS_FATE_HIT_CHANCE_PENALTY

func reset_gamblers_fate() -> void:
	curr_gamblers_fate_stacks = 0

func get_gamblers_fate_damage_multiplier() -> float:
	# TODO: Decide if this should be additive or multiplicitve
	return 1 + curr_gamblers_fate_stacks * GAMBLERS_FATE_PER_STACK_DAMAGE_INCREASE
