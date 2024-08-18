extends TextureButton	

func _ready():
	update_texture()

func _pressed():
	Global.curr_enemy.health -= Global.damage
	
	if (Global.curr_enemy.health <= 0): 
		Global.gold += Global.curr_enemy.gold_reward
		$"../../GoldAmount".update_gold()
		
		var rng = RandomNumberGenerator.new()
		Global.curr_enemy = Global.get_enemy(rng.randi_range(0, 1))
		
	$"..".update_enemy()

func update_texture():
	$".".texture_normal = load(Global.curr_enemy.image_url)
