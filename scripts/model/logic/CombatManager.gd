extends Node
class_name CombatManager

func deal_damage(source: UnitInstance, target: UnitInstance):
	var damage: int = source.get_attack_damage()
	var reduction: int = target.get_damage_reduction(damage)
	
	target.receive_damage(max(damage - reduction, 1))
