extends Button

var upgrade;

func _ready():
	var upgrade_id = int($"../UpgradeId".text)
	upgrade = Global.get_upgrade(upgrade_id)

func _pressed():
	$"../..".upgrade(upgrade)
	
func _process(_delta):
	check_buy()

func check_buy():
	if(Global.gold < upgrade.cost):
		$".".disabled = true;
	else:
		$".".disabled = false;
