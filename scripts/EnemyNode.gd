extends Node2D

@onready var enemy: EnemyInstance = GameManager.enemy

func _ready() -> void:
	GameManager.enemy_changed.connect(on_enemy_changed)
	GameManager.respawn_progress.connect(on_respawn_progress)
	GameManager.sync_enemy()

func on_respawn_progress(value: float, max: float) -> void:
	$ProgressBar.max_value = max
	$ProgressBar.value = value

func on_enemy_changed(new_enemy: EnemyInstance):
	if enemy:
		if enemy.is_connected("health_changed", on_health_changed):
			enemy.health_changed.disconnect(on_health_changed)
	
	enemy = new_enemy
	
	if enemy:
		enemy.health_changed.connect(on_health_changed)
	
	$ProgressBar.visible = (enemy == null)
	
	update_enemy_ui()
	update_enemy_health_ui()

func update_enemy_ui() -> void:
	if enemy == null:
		$EnemyBody.texture_normal = null
		$EnemyName.text = ""
		return
	
	$EnemyName.text = enemy.enemy_data.name
	$EnemyBody.texture_normal = enemy.enemy_data.texture

func update_enemy_health_ui() -> void:
	if enemy == null:
		$HealthBar/EnemyHealthLabel.text = ""
		return
	
	$HealthBar.max_value = enemy.max_health
	$HealthBar.value = enemy.health
	$HealthBar/EnemyHealthLabel.text = enemy.get_hp_str()

func on_health_changed() -> void:
	update_enemy_health_ui()

func _on_enemy_body_pressed() -> void:
	if enemy == null:
		return
	
	if !GameManager.player.can_attack():
		return
	
	GameManager.combat_manager.deal_damage(
		GameManager.player, GameManager.enemy
	)
	
	GameManager.player.start_attack_cooldown()
