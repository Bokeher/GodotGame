extends Button

const states = ["Idle", "Searching"]
var curr_state = 1

func _pressed():
	flip()
	
	# run away option - if there's an enemy and state is idle 
	if(curr_state == 0 && Global.curr_enemy):
		$"../Enemy".hide_enemy()
		$"../Enemy/HealthBar".value = 0
		Global.curr_enemy = null
		$"../Enemy".update_enemy()
	
	# if there's no enemy, loading bar is at 0% (to prevent restarting from 0 on resuming search) and state is searching
	if(curr_state == 1 && !Global.curr_enemy && $"../Enemy/HealthBar".value == 0):
		$"../Enemy/HealthBar".start_filling()
	
	update_action_button()

func flip():
	curr_state = (curr_state + 1) % 2

func update_action_button():
	$".".text = states[curr_state]
