extends Label

func update_level():
	var id: int = int($"../UpgradeId".text)
	var level: int = Global.upgrade_stats_array[id - 1].level
	$".".text = "Level " + str(level)
