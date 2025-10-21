class_name LuckswornClass

# GAMBLER'S FATE
const GAMBLERS_FATE_PER_STACK_DAMAGE_INCREASE: float = 0.2
const GAMBLERS_FATE_HIT_CHANCE_PENALTY: float = 0.16
var curr_gamblers_fate_stacks: int = 0

func increase_gamblers_fate() -> void:
	curr_gamblers_fate_stacks += 1

func get_gamblers_fate_hit_chance_multiplier() -> float:
	return 1 - GAMBLERS_FATE_HIT_CHANCE_PENALTY

func reset_gamblers_fate() -> void:
	curr_gamblers_fate_stacks = 0

func get_gamblers_fate_damage_multiplier() -> float:
	# TODO: Decide if this should be additive or multiplicitve
	return 1 + curr_gamblers_fate_stacks * GAMBLERS_FATE_PER_STACK_DAMAGE_INCREASE
