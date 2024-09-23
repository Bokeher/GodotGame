extends Button

var upgrade

func _ready():
	var upgrade_id = int($"../UpgradeId".text)
	upgrade = Global.get_upgrade(upgrade_id)
	update_cost()

func _pressed():
	$"../..".upgrade(upgrade)
	
func _process(_delta):
	check_buy()

func check_buy():
	if(Global.player_stats.gold < Global.upgrade_stats_array[upgrade.id - 1].cost):
		$".".disabled = true
	else:
		$".".disabled = false

func update_cost():
	var cost = Global.upgrade_stats_array[upgrade.id - 1].cost
	$".".text = str(cost)
