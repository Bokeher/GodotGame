extends Node2D

@onready var enemy: EnemyInstance = GameManager.enemy

func _ready() -> void:
	GameManager.enemy_changed.connect(on_enemy_changed)
	GameManager.respawn_progress.connect(on_respawn_progress)
	GameManager.sync_enemy()

func on_respawn_progress(value: float, max_value: float) -> void:
	$EnemyRespawnBar.max_value = max_value
	$EnemyRespawnBar.value = value

func on_enemy_changed(new_enemy: EnemyInstance):
	if enemy:
		if enemy.is_connected("health_changed", on_health_changed):
			enemy.health_changed.disconnect(on_health_changed)
		if enemy.is_connected("damaged", on_damaged):
			enemy.damaged.disconnect(on_damaged)
	
	enemy = new_enemy
	
	if enemy:
		enemy.damaged.connect(on_damaged)
		enemy.health_changed.connect(on_health_changed)
	
	$EnemyRespawnBar.visible = (enemy == null)
	
	update_enemy_ui()
	if enemy == null:
		update_enemy_health_ui(0)
	else:
		update_enemy_health_ui(enemy.health)

func on_damaged(_amount: int) -> void:
	$HitEnemySound.play_with_random_pitch()

func update_enemy_ui() -> void:
	if enemy == null:
		$EnemyBody.texture_normal = null
		$EnemyName.text = ""
		return
		
	$HealthBar.max_value = enemy.max_health
	$EnemyName.text = enemy.enemy_data.name
	$EnemyBody.texture_normal = enemy.enemy_data.texture

func update_enemy_health_ui(new_health: int) -> void:
	if enemy == null:
		$HealthBar/EnemyHealthLabel.text = ""
		return
	
	$HealthBar.value = new_health
	$HealthBar/EnemyHealthLabel.text = enemy.get_hp_str()

func on_health_changed(_old_health: int, new_health: int) -> void:
	update_enemy_health_ui(new_health)

func _on_enemy_body_pressed() -> void:
	if enemy == null:
		return
	
	GameManager.damage_resolver.deal_damage(
		GameManager.player, GameManager.enemy
	)
