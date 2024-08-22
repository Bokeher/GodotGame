extends TextureButton	

func _ready():
	update_texture()

func _pressed():
	Global.curr_enemy.health -= Global.damage
	
	if (Global.curr_enemy.health <= 0): 
		Global.gold += Global.curr_enemy.gold_reward
		$"../../GoldAmount".update_gold()
		
		var picked_enemy = pick_enemy()
		
		Global.curr_enemy = Global.get_enemy(picked_enemy)
		
	$"..".update_enemy()

func update_texture():
	$".".texture_normal = load(Global.curr_enemy.image_url)
	
func pick_enemy():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# Generate a random number between 0 and 1
	var random_value = rng.randf()

	var cumulative_chance = 0.0
	for enemy in Global.enemy_pool:
		cumulative_chance += enemy["spawn_chance"]
		if random_value < cumulative_chance:
			return enemy["enemy_id"]
