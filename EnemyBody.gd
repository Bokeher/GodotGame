extends TextureButton	

func _ready():
	update_texture()

func _pressed():
	Global.curr_enemy.health -= Global.damage
	
	if (Global.curr_enemy.health <= 0): 
		Global.gold += Global.curr_enemy.gold_reward
		$"../../Info/GoldAmount".update_gold()
		
		var picked_enemy = pick_enemy()
		
		# make enemy disapear for a brief moment
		$".".disabled = true
		Global.curr_enemy = null
		$"..".update_enemy()
		await get_tree().create_timer(0.05).timeout
		
		# set new enemy after apearing again
		$".".disabled = false
		Global.curr_enemy = Global.get_enemy(picked_enemy)
		$"../HealthBar".set_max_value_healthBar()
		
	$"..".update_enemy()

func update_texture():
	if(!Global.curr_enemy):
		$".".texture_normal = null
		return
	
	$".".texture_normal = load(Global.curr_enemy.image_url)
	
func pick_enemy():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var random_value = rng.randf()

	var cumulative_chance = 0.0
	for enemy in Global.enemy_pool:
		cumulative_chance += enemy["spawn_chance"]
		if random_value < cumulative_chance:
			return enemy["enemy_id"]
