extends Button

var upgrade

func _ready() -> void:
	var upgrade_id = $"../..".get_meta("upgrade_id")
	upgrade = Global.get_upgrade(upgrade_id)
	update_cost()

func _pressed() -> void:
	$"../..".upgrade(upgrade)
	
func _process(_delta) -> void:
	check_buy()

func check_buy() -> void:
	if(Global.player_stats.gold < Global.upgrade_stats_array[upgrade.id - 1].cost):
		$".".disabled = true
	else:
		$".".disabled = false

func update_cost() -> void:
	var cost = Global.upgrade_stats_array[upgrade.id - 1].cost
	$".".text = str(cost)
