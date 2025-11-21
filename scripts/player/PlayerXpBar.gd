extends ProgressBar

func _ready() -> void:
	update_xp_bar()

func update_xp_bar() -> void:
	var need_xp = 100 # TODO: replace this hardcoded value
	var curr_xp = Global.player.xp
	
	$PlayerXpProgressLabel.text = str(Global.player.xp) + " / " + str(need_xp)
	
	$".".max_value = need_xp
	$".".value = curr_xp
