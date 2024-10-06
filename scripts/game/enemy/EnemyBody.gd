extends TextureButton


func _ready() -> void:
	update_texture()

func _pressed() -> void:
	var damage = Global.player_stats.damage
	
	# change pitch to prevent repetitiveness
	$"../../AudioStreamPlayer".change_pitch()
	
	# check crit
	if(is_critical_hit()): 
		$"../../AudioStreamPlayer".change_crit_pitch()
		damage *= 2
	
	# play sound
	$"../../AudioStreamPlayer".play()
	
	Global.curr_enemy.health -= damage
	
	if (Global.curr_enemy.health <= 0): 
		# give reward for defeating enemy
		Global.player_stats.gold += Global.curr_enemy.gold_reward
		$"../../Info/GoldAmount".update_gold()
		
		# make enemy disapear
		Global.curr_enemy = null
		$".".disabled = true
		$"../HealthBar".update_healthBar()
		$"..".update_enemy()
		
		# start filling bar to show progress of finding new enemy
		var time_to_find_enemy = Global.calc_time_to_find_enemy()
		$"../HealthBar".start_filling(time_to_find_enemy)
		
		# "sleep"
		await get_tree().create_timer(time_to_find_enemy).timeout
		
		# pick new enemy
		var picked_enemy_id = pick_new_enemy_id()
		
		# set new enemy after apearing again
		Global.curr_enemy = Global.get_enemy(picked_enemy_id)
		$"../HealthBar".set_max_value_healthBar()
		
		# show enemy
		$".".disabled = false
		
		# make enemy start arracking
		$"../../Player_health".time_passed = 0
	
	$"..".update_enemy()

func update_texture() -> void:
	if(!Global.curr_enemy):
		$".".texture_normal = null
		return
	
	$".".texture_normal = load(Global.curr_enemy.image_url)
	
func pick_new_enemy_id() -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var random_value = rng.randf()

	var cumulative_chance = 0.0
	for enemy in Global.enemy_pool:
		cumulative_chance += enemy["spawn_chance"]
		if random_value < cumulative_chance:
			return enemy["enemy_id"]
	
	print("failed to pick new enemy id")
	return -1

func is_critical_hit() -> bool:
	var crit_chance = Global.player_stats.crit
	
	var random_value = randf()

	return random_value <= crit_chance
