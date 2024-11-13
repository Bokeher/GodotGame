extends ProgressBar

var filling_time = 0
var elapsed_time = 0.0

func _ready() -> void:
	# Dont fill healthbar (used to show progress of finding new enemies) 
	set_process(false) 
	
	set_max_value_healthBar()
	update_healthBar()

func _process(delta) -> void:
	if(!$"../../ActionButton".curr_state):
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
		set_new_enemy()
		
		$"../HealthBar".set_max_value_healthBar()
		
		# make enemy clickable
		$"..".show_enemy()
		
		# reset enemy attack cooldown to prevent instahit on spawn
		$"../../PlayerHealthBar/PlayerHealth".time_passed = 0
		
		# show enemy
		$"..".update_enemy()
		
		# disable the timer
		set_process(false)

func update_healthBar() -> void:
	if(!Global.curr_enemy):
		return
	
	$".".value = Global.curr_enemy.health

func set_max_value_healthBar() -> void:
	$".".max_value = Global.get_enemy(Global.curr_enemy.id).health

func start_filling() -> void:
	$".".value = 0
	elapsed_time = 0
	filling_time = Global.player_stats.calc_respawn_time()
	
	# start filling
	set_process(true)

func set_new_enemy() -> void:
	var cumulative_chance = 0.0
	
	var random_value = randf()
	
	for enemy in Global.curr_stage.enemies:
		cumulative_chance += enemy["spawn_chance"]
		if random_value < cumulative_chance:
			var new_enemy_id = enemy["enemy_id"]
			Global.curr_enemy = Global.get_enemy(new_enemy_id)
			return
	
	print("failed to pick new enemy")
	return
