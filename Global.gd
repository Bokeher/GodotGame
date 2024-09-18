extends Node

# file paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/enemies/enemies.json"
const PATH_STAGES: String = "res://assets/stages.json"
const PATH_UPGRADES: String = "res://assets/upgrades.json"

class PlayerStats:
	var damage: int = 1
	var crit: float = 0.00
	var speed: int = 1
	var wisdom: int = 1
	var luck: int = 1
	
	var gold: int = 0
	var max_stage_reached: int = 1

class UpgradeStats:
	var id: int
	var cost: float
	var cost_multiplier: float
	var level: int
	
	func _init(_id: int, _cost: float, _cost_multiplier: int, _level: int = 0):
		id = _id
		cost = _cost
		cost_multiplier = _cost_multiplier
		level = _level
	
	# used in saving
	func to_dict() -> Dictionary:
		return {
			"id": id,
			"cost": cost,
			"cost_multiplier": cost_multiplier,
			"level": level
		}
	
	# used in reading from savefile
	static func from_dict(data: Dictionary) -> UpgradeStats:
		var instance = UpgradeStats.new(
			data.get("id", -1),
			data.get("cost", -1),
			data.get("cost_multiplier", -1),
			data.get("level", -1)
		)
		
		return instance

# Saved vars
var player_stats: PlayerStats = PlayerStats.new()
var upgrade_stats_array: Array[UpgradeStats] = []

# State vars
var curr_enemy = null
var curr_stage = null
var enemy_pool = []

# Private vars - use getters to get them
var _enemies = []
var _stages = []
var _upgrades = []

# TODO: Decide if need to save curr_enemy
# TODO: Decide if need get_upgrade and get_stage

func _ready():
	read_stages()
	read_enemies()
	read_upgrades()
	
	read_savefile()
	
	if(upgrade_stats_array.is_empty()):
		for upgrade in _upgrades:
			var upgrade_stats = UpgradeStats.new(upgrade.id, upgrade.cost, upgrade.cost_multiplier)
			upgrade_stats_array.append(upgrade_stats)
	
	# Set curr_stage to max reached stage
	curr_stage = get_stage(player_stats.max_stage_reached)
	
	# Set enemy_pool to current's stage pool
	enemy_pool = curr_stage.enemies
	
	if(!curr_enemy):
		curr_enemy = get_enemy(0)

func read_savefile():
	if !FileAccess.file_exists(PATH_SAVE):
		print("File not found")
		return
	
	var file = FileAccess.open(PATH_SAVE, FileAccess.READ)
	
	var data = file.get_var()
	
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

func save_savefile():
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
	
	print("Saved")

# Auto save on exit
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_savefile()

func read_enemies():
	if(!FileAccess.file_exists(PATH_ENEMIES)):
		print("Enemies file not found")
		return
	
	var json_to_read = FileAccess.open(PATH_ENEMIES, FileAccess.READ)
	_enemies = JSON.parse_string(json_to_read.get_as_text()).enemies

func get_enemy(id: int):
	return _enemies[id - 1].duplicate()

func read_stages():
	if(!FileAccess.file_exists(PATH_STAGES)):
		print("Stages file not found")
		return
	
	var json_to_read = FileAccess.open(PATH_STAGES, FileAccess.READ)
	_stages = JSON.parse_string(json_to_read.get_as_text()).stages

func get_stage(id: int):
	return _stages[id - 1].duplicate()

func read_upgrades():
	if(!FileAccess.file_exists(PATH_UPGRADES)):
		print("Upgrades file not found")
		return
	
	var json_to_read = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	_upgrades = JSON.parse_string(json_to_read.get_as_text()).upgrades

func get_upgrade(id: int):
	return _upgrades[id - 1].duplicate()
