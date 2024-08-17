extends Node2D

func _ready():
	if(!Global.curr_enemy): 
		update_enemy()

func update_enemy():
	$EnemyBody.update_texture()
	$EnemyName.update_enemy_name()
	$EnemyHealth.update_enemy_health()
