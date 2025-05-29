extends Node2D

var isVisible: bool = true

func _ready() -> void:
	if(Global.curr_enemy): 
		update_enemy()
	
	update_enemy_name()

func update_enemy_name() -> void:
	if(!Global.curr_enemy):
		$EnemyName.text = ""
		return
	
	$EnemyName.text = str(Global.curr_enemy.name)

func update_enemy() -> void:
	$EnemyBody.update_enemy_sprite()
	update_enemy_name()
	$HealthBar.update_healthBar()

func hide_enemy() -> void:
	isVisible = false
	update_visibility()

func show_enemy() -> void:
	isVisible = true
	update_visibility()
	
	$"../ActionButton".text = "Run away"

func update_visibility() -> void:
	$EnemyAttackTimer.visible = isVisible
	$EnemyBody.disabled = !isVisible
