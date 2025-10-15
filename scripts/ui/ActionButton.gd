extends Button

enum States {
	IDLE = 0,
	SEARCH = 1
}

const STATES_TEXTS: Array[String] = ["Idle", "Searching"]
var curr_state: int = 1

func _pressed() -> void:
	flip()
	
	# Reset regen timer to prevent instaheal on stopping search
	$"../PlayerHealthBar/PlayerHealth".regen_time_passed = 0.7
	
	# Run away option
	if(curr_state == States.IDLE && Global.curr_enemy):
		$"../Enemy/HealthBar".value = 0
		Global.curr_enemy = null
		
		# TODO: create methods for removing enemy and finding and seperate enemy healthbar and finding bar
		$"../Enemy".hide_enemy()
		$"../Enemy".update_enemy()
	
	# Search option
	if (
		!Global.curr_enemy
		&& $"../Enemy/HealthBar".value == 0 # allows resuming search instead of starting from 0) 
		&& curr_state == States.SEARCH
	):
		$"../Enemy/HealthBar".start_filling()
	
	update_action_button()

func flip() -> void:
	curr_state = (curr_state + 1) % 2

func update_action_button() -> void:
	$".".text = STATES_TEXTS[curr_state]
