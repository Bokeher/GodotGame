extends Control

var upgrade: Upgrade

func _ready() -> void:
	var upgrade_id = $".".get_meta("upgrade_id")
	upgrade = Global.upgrades[upgrade_id - 1]
	update_cost(upgrade.cost)
	
	$".".set_custom_minimum_size($Background.size)
	update_level(upgrade.level, upgrade.max_level)

func performUpgrade() -> void:
	var cost = upgrade.cost
	
	# dont need to check anything here since this interaction is only 
	# available when button is active
	
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
	
	update_cost(upgrade.cost)
	update_level(upgrade.level, upgrade.max_level)
	
	$"../../../GoldAmount".update_gold()
	$"../../../../StatsPanel/Stats".update_stats()

func check_buy() -> void:
	if(upgrade.max_level != -1 && upgrade.level >= upgrade.max_level):
		$Background/UpgradeButton.disabled = true
		return
	
	if(Global.player_stats.gold < upgrade.cost):
		$Background/UpgradeButton.disabled = true
	else:
		$Background/UpgradeButton.disabled = false

# TODO: delete this if not needed after reset button deleted
func update_upgrade() -> void:
	upgrade = Global.upgrades[upgrade.id - 1]
	
	update_level(upgrade.level, upgrade.max_level)
	$Background/UpgradeButton.update_cost(upgrade.cost)

func _process(_delta) -> void:
	check_buy()

func _on_upgrade_button_pressed() -> void:
	performUpgrade()

func update_level(level: int, max_level: int) -> void:
	var level_text = "Level " + str(level)
	
	if(max_level > 0):
		level_text += " / " + str(max_level) 
	
	$Background/Level.text = level_text

func update_cost(cost: int) -> void:
	$Background/UpgradeButton.text = str(cost)
