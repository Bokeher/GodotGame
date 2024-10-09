extends Button

const states = ["Idle", "Searching"]
var curr_state = 0

func _pressed():
	flip()

func flip():
	curr_state = (curr_state + 1) % 2
	$".".text = states[curr_state]
