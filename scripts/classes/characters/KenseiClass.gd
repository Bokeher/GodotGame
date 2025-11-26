class_name KenseiClass

# SWORD'S PATH
var swords_path_lines_amount: int = 0
const SWORDS_PATH_BASE_MAX_STACKS: int = 5
const SWORDS_PATH_BASE_DAMAGE_MULTIPLIER: float = 0.1
const SWORDS_PATH_BASE_COOLDOWN: float = 2.0

# SHARP EDGE
const SHARP_EDGE_VALUES: Array[float] = [0, 0.01, 0.03, 0.05]

# INSTINCTS
const SWORDSMASTER_INSTINCT_BASE_THRESHOLD: float = 1.2
const IMPROVED_INSTINCT_BASE_VALUE: float = 0.05
const DULLED_INSTINCT_BASE_VALUE: float = 0.05

# MASTER'S TEMPO
var masters_tempo_stack_count: int = 0
const MASTERS_TEMPO_VALUES: Array[int] = [0, 10, 9, 8, 7, 5]

# IMPROVED TEMPO
const IMPROVED_TEMPO_VALUES: Array[int] = [0, 1, 2, 4]

## Return true if this skill should work, else false (25/50/100% chance to true based on skill level)
func process_improved_tempo(skill_level: int) -> bool:
	if skill_level == 0: return false
	
	var random: int = randi_range(1, 4) # 1-4
	
	return random <= IMPROVED_TEMPO_VALUES[skill_level] # 1-4 < 1/2/4

## Return true on stack reset else false
func increase_masters_tempo() -> bool:
	var masters_tempo: Skill = Global.skills[Enums.KenseiSkillIds.MASTERS_TEMPO - 1]
	if masters_tempo.level == 0:
		return false
	
	var stacks_to_proc: int = MASTERS_TEMPO_VALUES[masters_tempo.level]
	var exquisit_tempo: Skill = Global.skills[Enums.KenseiSkillIds.EXQUISIT_TEMPO - 1]
	if exquisit_tempo.level == 1:
		stacks_to_proc = 3
	
	# Increase by 1 and reset if on max stack
	masters_tempo_stack_count = wrapi(masters_tempo_stack_count + 1, 0, stacks_to_proc)
	
	return masters_tempo_stack_count == 0

func get_instinct_threshold() -> float:
	var improved_instinct: Skill = Global.skills[Enums.KenseiSkillIds.IMPROVED_INSTINCT - 1]
	var dulled_instinct: Skill = Global.skills[Enums.KenseiSkillIds.DULLED_INSTINCT - 1]
	
	var decrease_threshold := improved_instinct.level * IMPROVED_INSTINCT_BASE_VALUE
	var increase_threshold := dulled_instinct.level * DULLED_INSTINCT_BASE_VALUE
	
	return SWORDSMASTER_INSTINCT_BASE_THRESHOLD - decrease_threshold + increase_threshold
