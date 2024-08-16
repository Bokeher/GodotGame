extends TextureButton	

func _pressed():
	Global.enemy_health -= Global.damage
	
	if (Global.enemy_health <= 0): 
		Global.enemy_health = 100
		Global.gold += 1
		$"../../GoldAmount".update_gold()
	
	$"../EnemyHealth".text = str(Global.enemy_health) + " HP"
