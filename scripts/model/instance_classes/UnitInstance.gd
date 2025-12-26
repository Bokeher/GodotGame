extends Resource
class_name UnitInstance

@export var health: int
@export var max_health: int

signal health_changed()
signal died(instance)

func receive_damage(amount: int) -> void:
	if amount <= 0:
		return
	
	health = max(health - amount, 0)
	health_changed.emit()
	
	if health == 0:
		died.emit(self)

func get_damage_reduction(incoming_damage: int) -> int:
	return 0

# ABSTRACT METHOD
func get_attack_damage() -> int:
	assert(false, "UnitInstance.get_attack_damage() must be overridden")
	return 0

func get_hp_str() -> String:
	return "%d / %d HP" % [health, max_health]
