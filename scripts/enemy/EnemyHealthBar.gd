extends ProgressBar

var filling_time: float = 0
var elapsed_time: float = 0.0

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
	var progress: float = elapsed_time / filling_time
	var time_to_show: float = floor((1.0 - progress) * filling_time * 10.0) / 10.0
	
	# Update the ProgressBar value
	$".".value = progress
	
	$EnemyHealthLabel.text = str(time_to_show) + "s"
	
	# Stop updating once the fill is complete
	if progress >= 1.0:
		Enemy.set_new_random_enemy()
		
		$"../HealthBar".set_max_value_healthBar()
		
		# Make enemy clickable
		$"..".show_enemy()
		
		# Reset enemy attack cooldown to prevent instahit on spawn
		$"../../PlayerHealthBar/PlayerHealth".attack_time_passed = 0
		
		# Show enemy
		$"..".update_enemy()
		
		# Disable the timer
		set_process(false)
		
		await get_tree().create_timer(0.10).timeout
		$"../EnemyBody".deal_damage_to_enemy(Global.warrior_class.curr_overkill_damage)
		Global.warrior_class.curr_overkill_damage = 0

func update_healthBar() -> void:
	if(!Global.curr_enemy):
		$EnemyHealthLabel.text = ""
		return
	
	$".".value = Global.curr_enemy.health
	$EnemyHealthLabel.text = str(Global.curr_enemy.health) + " HP"

func set_max_value_healthBar() -> void:
	$".".max_value = Enemy.get_enemy(Global.curr_enemy.id).health

func start_filling() -> void:
	$".".value = 0
	elapsed_time = 0
	filling_time = Global.player.calc_respawn_time()
	
	# Start filling
	set_process(true)
