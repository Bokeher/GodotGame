extends TextureButton

func _ready() -> void:
	update_enemy_sprite()

func _pressed() -> void:
	var damage = Global.player_stats.damage
	
	# Check crit
	if(is_critical_hit()):
		$"../../HitEnemySound".change_pitch(true)
		damage *= Global.player_stats.crit_multiplier
	else:
		$"../../HitEnemySound".change_pitch()
		
	# Play sound
	$"../../HitEnemySound".play()
	
	Global.curr_enemy.health -= damage
	
	if (Global.curr_enemy.health <= 0):
		# Reset regen timer to prevent instaheal on killing enemy
		$"../../PlayerHealthBar/PlayerHealth".regen_time_passed = 0
		
		# Give reward for defeating enemy
		Global.player_stats.gold += Global.curr_enemy.gold_reward
		var leveled_up: bool = Global.player_stats.add_xp(Global.curr_enemy.xp_reward)
		$"../../MainTabContainer/UpgradesPanel/GoldAmount".update_gold()
		
		# Drop items
		var dropped_item_ids = Global.curr_enemy.get_loot()
		for item_id in dropped_item_ids:
			Global.inventory[item_id] = Global.inventory.get(item_id, 0) + 1
		
		# Make enemy disapear
		Global.curr_enemy = null
		$"..".hide_enemy()
		
		# Start filling bar to show progress of finding new enemy
		$"../HealthBar".start_filling()
		$"../../PlayerXpBar".update_xp_bar()
		$"../../MainTabContainer/StatsPanel/Stats".update_stats()
		
		if(leveled_up):
			$"../../MainTabContainer/SkillsPanel/SkillPointsAmount".update_skill_points()
	
	$"..".update_enemy()

func update_enemy_sprite() -> void:
	if(!Global.curr_enemy):
		$".".texture_normal = null
		return
	
	$".".texture_normal = load(Global.curr_enemy.image_path)

func is_critical_hit() -> bool:
	return randf() <= Global.player_stats.crit_chance
