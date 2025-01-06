extends Label

func update_level() -> void:
	var id: int = $"../..".get_meta("upgrade_id")
	
	var upgrade = Global._upgrades[id - 1]
	
	var level_text = "Level " + str(upgrade.level)
	
	if(upgrade.max_level > 0):
		level_text += " / " + str(upgrade.max_level) 
	
	$".".text = level_text
