extends Node
class_name DamageResolver

func deal_damage(source: UnitInstance, target: UnitInstance) -> void:
	var damage: int = source.get_attack_damage()
	var reduction: int = target.get_damage_reduction(damage)
	
	target.receive_damage(max(damage - reduction, 1))
