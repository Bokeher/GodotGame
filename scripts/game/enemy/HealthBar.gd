extends ProgressBar

var filling_time = 0
var elapsed_time = 0.0

func _ready():
	# Dont fill healthbar (used to show progress of finding new enemies) 
	set_process(false) 
	
	set_max_value_healthBar()
	update_healthBar()

func _process(delta):
	if(!$"../../Search".curr_state):
		return
	
	# Set max to 100%
	$".".max_value = 1
	
	elapsed_time += delta

	# Calculate the progress based on elapsed time and the fill duration
	var progress = elapsed_time / filling_time

	# Clamp progress to be between 0 and 1
	progress = clamp(progress, 0.0, 1.0)
	
	# Update the ProgressBar value
	$".".value = progress
	
	$EnemyHealth.text = str(1 - floor(progress * 10) / 10) + "s"
	
	# Stop updating once the fill is complete
	if progress >= 1.0:
		# set new enemy
		var picked_enemy_id = pick_new_enemy_id()
		Global.curr_enemy = Global.get_enemy(picked_enemy_id)
		$"../HealthBar".set_max_value_healthBar()
		
		# make enemy clickable
		$"..".show_enemy()
		
		# reset enemy attack cooldown to prevent instahit on spawn
		$"../../PlayerHealthBar/PlayerHealth".time_passed = 0
		
		# show enemy
		$"..".update_enemy()
		
		# disable the timer
		set_process(false)

func update_healthBar():
	if(!Global.curr_enemy):
		return
	
	$".".value = Global.curr_enemy.health

func set_max_value_healthBar():
	$".".max_value = Global.get_enemy(Global.curr_enemy.id).health

func start_filling():
	$".".value = 0
	elapsed_time = 0
	filling_time = Global.calc_time_to_find_enemy()
	
	# start filling
	set_process(true)

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
