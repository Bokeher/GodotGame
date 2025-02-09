extends ProgressBar

func _ready():
	update_xp_bar()

func update_xp_bar():
	var need_xp = 100 # TODO: replace this hardcoded value
	var curr_xp = Global.player_stats.xp
	
	$PlayerXpProgressLabel.text = str(Global.player_stats.xp) + " / " + str(need_xp)
	
	$".".max_value = need_xp
	$".".value = curr_xp
