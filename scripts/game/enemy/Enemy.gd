extends Node2D

func _ready():
	if(Global.curr_enemy): 
		update_enemy()

func update_enemy():
	$EnemyBody.update_texture()
	$EnemyName.update_enemy_name()
	$HealthBar/EnemyHealth.update_enemy_health()
	$HealthBar.update_healthBar()

func hide_enemy():
	$EnemyAttackTimer.visible = false
	$EnemyBody.disabled = true

func show_enemy():
	$EnemyAttackTimer.visible = true
	$EnemyBody.disabled = false
