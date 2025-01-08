extends Control

var upgrade: Upgrade

func _ready() -> void:
	var upgrade_id = $".".get_meta("upgrade_id")
	upgrade = Global._upgrades[upgrade_id - 1]
	$Background/UpgradeButton.update_cost(upgrade.cost)
	
	$".".set_custom_minimum_size($Background.size)
	$Background/Level.update_level(upgrade.level, upgrade.max_level)

func performUpgrade() -> void:
	var cost = upgrade.cost
	
	if(Global.player_stats.gold < cost):
		# TODO: Show to user
		print("Not enough gold")
		return
	
	Global.player_stats.gold -= cost
	
	var id = upgrade.id
	if(id == 1):
		Global.player_stats.damage += upgrade.value
	elif(id == 2):
		Global.player_stats.crit_chance += (float(upgrade.value) / 100)
	elif(id == 3):
		Global.player_stats.speed += upgrade.value
	elif(id == 4):
		Global.player_stats.wisdom += upgrade.value
	elif(id == 5):
		Global.player_stats.luck += upgrade.value
	
	upgrade.level += 1
	upgrade.cost = int(upgrade.cost * upgrade.cost_multiplier)
	
	$Background/UpgradeButton.update_cost(upgrade.cost)
	$Background/Level.update_level(upgrade.level, upgrade.max_level)
	
	$"../../../GoldAmount".update_gold()
	$"../../../../StatsPanel/Stats".update_stats()

func check_buy() -> void:
	if(Global.player_stats.gold < upgrade.cost):
		$Background/UpgradeButton.disabled = true
	else:
		$Background/UpgradeButton.disabled = false

# TODO: delete this if not needed after reset button deleted
func update_upgrade() -> void:
	upgrade = Global._upgrades[upgrade.id - 1]
	
	$Background/Level.update_level(upgrade.level, upgrade.max_level)
	$Background/UpgradeButton.update_cost(upgrade.cost)

func _process(_delta) -> void:
	check_buy()
	
