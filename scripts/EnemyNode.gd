extends Node2D

@onready var enemy: EnemyInstance = GameManager.enemy

func _ready() -> void:
	GameManager.enemy_changed.connect(on_enemy_changed)
	
	on_enemy_changed(GameManager.enemy)

func on_enemy_changed(new_enemy: EnemyInstance):
	if enemy:
		if enemy.is_connected("health_changed", on_health_changed):
			enemy.health_changed.disconnect(on_health_changed)
	
	enemy = new_enemy
	
	if enemy:
		enemy.health_changed.connect(on_health_changed)
	
	update_health_ui()

func update_health_ui() -> void:
	$HealthBar.max_value = enemy.max_health
	$HealthBar.value = enemy.health
	$HealthBar/EnemyHealthLabel.text = enemy.get_hp_str()

func on_health_changed() -> void:
	update_health_ui()
