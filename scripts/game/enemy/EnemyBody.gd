extends TextureButton

func _ready() -> void:
	update_texture()

func _pressed() -> void:
	var damage = Global.player_stats.damage
	
	# change pitch to prevent repetitiveness
	$"../../HitEnemySound".change_pitch()
	
	# check crit
	if(is_critical_hit()): 
		$"../../HitEnemySound".change_crit_pitch()
		damage *= 2
	
	# play sound
	$"../../HitEnemySound".play()
	
	Global.curr_enemy.health -= damage
	
	if (Global.curr_enemy.health <= 0): 
		# reset regen timer to prevent instaheal on killing enemy
		$"../../PlayerHealthBar/PlayerHealth".regen_time_passed = 0
		
		# give reward for defeating enemy
		Global.player_stats.gold += Global.curr_enemy.gold_reward
		$"../../Info/GoldAmount".update_gold()
		
		# make enemy disapear
		Global.curr_enemy = null
		$"..".hide_enemy()
		
		# start filling bar to show progress of finding new enemy
		$"../HealthBar".start_filling()
	
	$"..".update_enemy()

func update_texture() -> void:
	if(!Global.curr_enemy):
		$".".texture_normal = null
		return
	
	$".".texture_normal = load(Global.curr_enemy.image_url)

func is_critical_hit() -> bool:
	return randf() <= Global.player_stats.crit
