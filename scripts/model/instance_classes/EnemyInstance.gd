extends UnitInstance
class_name EnemyInstance

@export var enemy_data: EnemyData

func _init(enemy_data_: EnemyData) -> void:
	enemy_data = enemy_data_
	health = enemy_data.health
	max_health = enemy_data.health

func get_damage_reduction(incoming_damage: int) -> int:
	return max(incoming_damage - enemy_data.defense, 1)

func get_dropped_loot() -> Array[ItemData]:
	var drops: Array[ItemData] = []
	
	for entry: LootEntry in enemy_data.loot_table:
		if randf() <= entry.drop_chance:
			drops.append(entry.item)
	
	return drops
