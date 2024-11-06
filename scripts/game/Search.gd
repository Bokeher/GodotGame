extends Button

const IDLE_STATE = 0
const SEARCH_STATE = 1
const STATES_TEXTS = ["Idle", "Searching"]
var curr_state = 1

func _pressed() -> void:
	flip()
	
	# reset regen timer to prevent instaheal on stopping search
	$"../PlayerHealthBar/PlayerHealth".regen_time_passed = 0.7
	
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

func flip() -> void:
	curr_state = (curr_state + 1) % 2

func update_action_button() -> void:
	$".".text = STATES_TEXTS[curr_state]
