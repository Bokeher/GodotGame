extends Node2D

func _ready() -> void:
	if(Global.curr_enemy): 
		update_enemy()

func update_enemy() -> void:
	$EnemyBody.update_texture()
	$EnemyName.update_enemy_name()
	$HealthBar/EnemyHealth.update_enemy_health()
	$HealthBar.update_healthBar()

func hide_enemy() -> void:
	$EnemyAttackTimer.visible = false
	$EnemyBody.disabled = true

func show_enemy() -> void:
	$"../ActionButton".text = "Run away"
	$EnemyAttackTimer.visible = true
	$EnemyBody.disabled = false
