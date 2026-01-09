extends Resource
class_name UnitInstance

@export var health: int
@export var max_health: int

signal health_changed(old_value: int, new_value: int)
signal damaged(amount: int)
signal died(instance: UnitInstance)

func receive_damage(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return
	
	var old_health := health
	health = max(health - amount, 0)
	
	if health < old_health:
		damaged.emit(old_health - health)
		health_changed.emit(old_health, health)
	
	if health == 0:
		died.emit(self)

func get_damage_reduction(_incoming_damage: int) -> int:
	return 0

# ABSTRACT METHOD
func get_attack_damage() -> int:
	assert(false, "UnitInstance.get_attack_damage() must be overridden")
	return 0

func get_hp_str() -> String:
	return "%d / %d HP" % [health, max_health]
