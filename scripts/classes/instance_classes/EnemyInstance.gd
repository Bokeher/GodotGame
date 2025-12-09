extends Object
class_name EnemyInstance

@export var enemy_data: EnemyData
@export var health: int

signal hit(damage: int)
signal died(enemy: EnemyInstance)

func _init(enemy_data: EnemyData) -> void:
	self.enemy_data = enemy_data
	health = enemy_data.health

func deal_damage(damage: int) -> void:
	health -= damage
	
	hit.emit(damage)
	
	if health <= 0:
		die()

func die() -> void:
	died.emit(self)
