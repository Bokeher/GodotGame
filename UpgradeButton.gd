extends Button

func _pressed():
	var upgrade_id = int($"../UpgradeId".text)
	
	var upgrade = Global.get_upgrade(upgrade_id)
	$"../..".upgrade(upgrade.cost, upgrade.value)
