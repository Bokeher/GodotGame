extends Object
class_name EnemyInstance

@export var enemy_data: EnemyData
@export var health: int

signal hit(damage: int)
signal died(enemy: EnemyInstance)

func _init(enemy_data_: EnemyData) -> void:
	enemy_data = enemy_data_
	health = enemy_data.health

func deal_damage(damage: int) -> void:
	health -= damage
	
	hit.emit(damage)
	
	if health <= 0:
		die()

func die() -> void:
	died.emit(self)

func get_dropped_loot() -> Array[ItemData]:
	var drops: Array[ItemData] = []
	
	for entry: LootEntry in enemy_data.loot_table:
		if randf() <= entry.drop_chance:
			drops.append(entry.item)
	
	return drops
