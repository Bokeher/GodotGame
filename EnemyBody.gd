extends TextureButton	

func _pressed():
	Global.curr_enemy.health -= Global.damage
	
	if (Global.curr_enemy.health <= 0): 
		Global.gold += Global.curr_enemy.gold_reward
		$"../../GoldAmount".update_gold()
		
		# TODO: make other enemies spawn after this one dies
		Global.curr_enemy = Global.get_enemy(1)
		
	$"..".update_enemy()

func update_texture():
	$".".texture_normal = load(Global.curr_enemy.image_url)
