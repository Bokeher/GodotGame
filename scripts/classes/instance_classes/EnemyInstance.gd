extends Object
class_name EnemyInstance

@export var enemy_data: EnemyData
@export var health: int

func _init(enemy_data: EnemyData) -> void:
	self.enemy_data = enemy_data
	health = enemy_data.health
