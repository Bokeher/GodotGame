extends Button

const IDLE_STATE = 0
const SEARCH_STATE = 1
const STATES_TEXTS = ["Idle", "Searching"]
var curr_state = 1

func _pressed() -> void:
	flip()
	
	# Reset regen timer to prevent instaheal on stopping search
	$"../PlayerHealthBar/PlayerHealth".regen_time_passed = 0.7
	
	# run away option - if there's an enemy and state is idle 
	if(curr_state == 0 && Global.curr_enemy):
		$"../Enemy/HealthBar".value = 0
		Global.curr_enemy = null
		
		$"../Enemy".hide_enemy()
		$"../Enemy".update_enemy()
	
	# If no enemy
	# AND loading bar is at 0% (this allows resuming search instead of starting from 0) 
	# AND state is searching
	if (
		!Global.curr_enemy 
		&& $"../Enemy/HealthBar".value == 0 
		&& curr_state == SEARCH_STATE
	):
		$"../Enemy/HealthBar".start_filling()
	
	update_action_button()

func flip() -> void:
	curr_state = (curr_state + 1) % 2

func update_action_button() -> void:
	$".".text = STATES_TEXTS[curr_state]
