extends Node

# Load classes
const UpgradeStats = preload("res://scripts/classes/UpgradeStats.gd")
const PlayerStats = preload("res://scripts/classes/PlayerStats.gd")

# File paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/jsons/enemies.json"
const PATH_STAGES: String = "res://assets/jsons/stages.json"
const PATH_UPGRADES: String = "res://assets/jsons/upgrades.json"

# State vars
var curr_enemy = null
var curr_stage = null
var enemy_pool = []
var player_stats: PlayerStats = PlayerStats.new()
var upgrade_stats_array: Array[UpgradeStats] = []

# Private vars - use getters to get them
var _enemies = []
var _stages = []
var _upgrades = []

# Auto save vars
const AUTO_SAVE_INTERVAL = 5.0
var auto_save_timer = 0.0

func _ready() -> void:
	read_stages()
	read_enemies()
	read_upgrades()
	
	read_savefile()
	
	# if not loaded from savefile or when adding new upgrades (dev)
	if(upgrade_stats_array.is_empty() or upgrade_stats_array.size() != _upgrades.size()):
		# reset upgrade stats array and fill it from upgrades list 
		load_upgrade_stats()
	
	# Set curr_stage to max reached stage
	curr_stage = get_stage(player_stats.max_stage_reached)
	
	# Set enemy_pool to current's stage pool
	enemy_pool = curr_stage.enemies
	
	if(!curr_enemy):
		curr_enemy = get_enemy(0)

func load_upgrade_stats() -> void:
	upgrade_stats_array = []
	
	for upgrade in _upgrades:
		var upgrade_stats = UpgradeStats.new(upgrade.id, upgrade.cost, upgrade.cost_multiplier)
		upgrade_stats_array.append(upgrade_stats)

func read_savefile() -> void:
	if !FileAccess.file_exists(PATH_SAVE):
		print("File not found")
		return
	
	var file = FileAccess.open(PATH_SAVE, FileAccess.READ)
	
	var data = file.get_var()
	
	file.close()
	
	var stats = data[0]
	curr_enemy = data[1]
	
	var upgrade_stats_dicts = data[2]
	
	for upgrade_stats_dict in upgrade_stats_dicts:
		upgrade_stats_array.append(UpgradeStats.from_dict(upgrade_stats_dict))
	
	player_stats.damage = stats[0]
	player_stats.crit = stats[1]
	player_stats.speed = stats[2]
	player_stats.wisdom = stats[3]
	player_stats.luck = stats[4]
	
	player_stats.gold = stats[5]
	player_stats.max_stage_reached = stats[6]

func save_savefile() -> void:
	var file = FileAccess.open(PATH_SAVE, FileAccess.WRITE)
	
	var upgrade_stats_dict = []
	for upgrade_stats in upgrade_stats_array:
		upgrade_stats_dict.append(upgrade_stats.to_dict())
	
	var save_data = [
		[
			player_stats.damage,
			player_stats.crit,
			player_stats.speed,
			player_stats.wisdom,
			player_stats.luck,
			
			player_stats.gold,
			player_stats.max_stage_reached
		],
		curr_enemy,
		upgrade_stats_dict
	]
	
	file.store_var(save_data)
	
	file.close()
	print("Saved")

# Save on exit
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_savefile()

# Auto save 
func _process(delta) -> void:
	auto_save_timer += delta
	if auto_save_timer >= AUTO_SAVE_INTERVAL:
		save_savefile()
		auto_save_timer = 0.0

func read_enemies() -> void:
	if(!FileAccess.file_exists(PATH_ENEMIES)):
		print("Enemies file not found")
		return
	
	var file = FileAccess.open(PATH_ENEMIES, FileAccess.READ)
	_enemies = JSON.parse_string(file.get_as_text()).enemies
	file.close()

# TODO: add type after adding Enemy class
func get_enemy(id: int):
	return _enemies[id - 1].duplicate()

func read_stages() -> void:
	if(!FileAccess.file_exists(PATH_STAGES)):
		print("Stages file not found")
		return
	
	var file = FileAccess.open(PATH_STAGES, FileAccess.READ)
	_stages = JSON.parse_string(file.get_as_text()).stages
	file.close()

# TODO: add type after adding Stage class
func get_stage(id: int):
	return _stages[id - 1].duplicate()

func read_upgrades() -> void:
	if(!FileAccess.file_exists(PATH_UPGRADES)):
		print("Upgrades file not found")
		return
	
	var file = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	_upgrades = JSON.parse_string(file.get_as_text()).upgrades
	file.close()

# TODO: add type after adding Upgrade class
func get_upgrade(id: int):
	return _upgrades[id - 1].duplicate()

func calc_time_to_find_enemy() -> float:
	return 1.1 - player_stats.speed * 0.1
