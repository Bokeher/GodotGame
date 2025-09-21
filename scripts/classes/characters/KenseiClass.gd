class_name KenseiClass

# stores current values
var swords_path_lines_amount: int = 0
var masters_tempo_curr_stack_amount: int = 1

# static values
var swords_path_base_max_stacks: int = 5
var swords_path_base_damage_multiplier: float = 0.1
var swords_path_base_cooldown: float = 2.0

var sharp_edge_values: Array[float] = [0, 0.01, 0.03, 0.05]

var swordsmaster_instinct_base_threshold: float = 1.2
var improved_instinct_base_value: float = 0.05
var dulled_instinct_base_value: float = 0.05

var masters_tempo_values: Array[int] = [0, 10, 9, 8, 7, 5]

## Return true if this skill should work, else false (25/50/100% chance to true based on skill level)
func process_improved_tempo(skill_level: int) -> bool:
	if skill_level == 0: return false
	
	var random: int = randi_range(1, 4) # 1-4
	
	return random <= get_improved_tempo_value(skill_level) # 1-4 < 1/2/4

## Use bit shift to get these values 1 -> 1, 2 -> 2, 3 -> 4
func get_improved_tempo_value(i: int) -> int:
	return 1 << (i - 1)

## Return true on stack reset else false
func increase_masters_tempo(masters_tempo_level: int) -> bool:
	if masters_tempo_level == 0:
		return false
	
	# Increase by 1 and reset if on max stack
	masters_tempo_curr_stack_amount = wrapi(masters_tempo_curr_stack_amount + 1, 0, masters_tempo_values[masters_tempo_level] + 1)
	
	return masters_tempo_curr_stack_amount == 0

func get_instinct_threshold() -> float:
	var improved_instinct: Skill = Global.skills[Enums.KenseiSkillIds.IMPROVED_INSTINCT - 1]
	var dulled_instinct: Skill = Global.skills[Enums.KenseiSkillIds.DULLED_INSTINCT - 1]
	
	var decrease_threshold = improved_instinct.level * improved_instinct_base_value
	var increase_threshold = dulled_instinct.level * dulled_instinct_base_value
	
	return swordsmaster_instinct_base_threshold - decrease_threshold + increase_threshold
