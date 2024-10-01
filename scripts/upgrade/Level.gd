extends Label

func update_level():
	var id: int = int($"../UpgradeId".text)
	
	var level: int = Global.upgrade_stats_array[id - 1].level
	var max_level: int = Global.get_upgrade(id).max_level
	
	var level_text = "Level " + str(level)
	
	if(max_level > 0):
		level_text += " / " + str(max_level) 

	$".".text = level_text
