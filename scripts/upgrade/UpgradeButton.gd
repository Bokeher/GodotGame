extends Button

var upgrade: Upgrade

func _ready() -> void:
	var upgrade_id = $"../..".get_meta("upgrade_id")
	upgrade = Global._upgrades[upgrade_id - 1]
	update_cost()

func _pressed() -> void:
	$"../..".upgrade(upgrade)
	
func _process(_delta) -> void:
	check_buy()

func check_buy() -> void:
	if(Global.player_stats.gold < upgrade.cost):
		$".".disabled = true
	else:
		$".".disabled = false

func update_cost() -> void:
	$".".text = str(upgrade.cost)
