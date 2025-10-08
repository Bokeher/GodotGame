class_name WarriorClass

var adrenalineStacks: int = 0
var ADRENALINE_DAMAGE_INCREASE_PER_LEVEL: float = 0.25

func add_adrenaline_stack() -> void:
	var adrenaline: Skill = Global.skills[Enums.WarriorSkillIds.ADRENALINE - 1]
	
	if adrenaline.level == 0:
		return
	
	adrenalineStacks += 1

func get_adrenaline_damage_multiplier() -> float:
	var adrenaline: Skill = Global.skills[Enums.WarriorSkillIds.ADRENALINE - 1]
	
	if adrenaline.level == 0:
		return 1
	
	var bonus_multiplier: float = (adrenaline.level * ADRENALINE_DAMAGE_INCREASE_PER_LEVEL)
	
	return 1 + bonus_multiplier * adrenalineStacks
