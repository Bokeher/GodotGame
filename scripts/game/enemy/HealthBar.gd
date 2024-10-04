extends ProgressBar

var filling_time = 0
var elapsed_time = 0.0

func _ready():
	# Dont fill healthbar (used to show progress of finding new enemies) 
	set_process(false) 
	
	set_max_value_healthBar()
	update_healthBar()

func _process(delta):
	# Set max to 100%
	$".".max_value = 1
	
	elapsed_time += delta

	# Calculate the progress based on elapsed time and the fill duration
	var progress = elapsed_time / filling_time

	# Clamp progress to be between 0 and 1
	progress = clamp(progress, 0.0, 1.0)
	
	# Update the ProgressBar value
	$".".value = progress

	# Stop updating once the fill is complete
	if progress >= 1.0:
		set_process(false)

func update_healthBar():
	if(!Global.curr_enemy):
		return
	
	$".".value = Global.curr_enemy.health

func set_max_value_healthBar():
	$".".max_value = Global.get_enemy(Global.curr_enemy.id).health

func start_filling(time_to_fill: float):
	elapsed_time = 0
	filling_time = time_to_fill
	set_process(true)
