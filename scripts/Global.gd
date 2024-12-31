extends Node

# File paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/jsons/enemies.json"
const PATH_STAGES: String = "res://assets/jsons/stages.json"
const PATH_UPGRADES: String = "res://assets/jsons/upgrades.json"
const PATH_SKILLS: String = "res://assets/jsons/skills.json"

# Used to precisely set postion of Popups based on position of MainTabContainer 
const MAIN_TAB_CONTAINER_POSITION = Vector2i(580, 0)

# State vars
var curr_enemy: Enemy
var curr_stage = null
var player_stats: PlayerStats = PlayerStats.new()
var upgrade_stats_array: Array[UpgradeStats] = []

# Private vars - use getters to get them
var _enemies: Array[Enemy] = []
var _stages = []
var _upgrades: Array[Upgrade] = []
var _skills: Array[Skill] = []

# Auto save vars
const AUTO_SAVE_INTERVAL = 5.0
var auto_save_timer = 0.0

func _ready() -> void:
	# Read all json files
	read_stages()
	read_enemies()
	read_upgrades()
	read_skills()
	
	read_savefile()
	
	# If not loaded from savefile or when adding new upgrades (dev)
	if(upgrade_stats_array.is_empty() or upgrade_stats_array.size() != _upgrades.size()):
		# Reset upgrade stats array and fill it from upgrades list 
		load_upgrade_stats()
	
	# Set curr_stage to max reached stage
	curr_stage = get_stage(player_stats.max_stage_reached)
	
	if(!curr_enemy):
		curr_enemy = get_enemy(1)

func load_upgrade_stats() -> void:
	upgrade_stats_array = []
	
	for upgrade in _upgrades:
		var upgrade_stats = UpgradeStats.new(upgrade.id, upgrade.cost, upgrade.cost_multiplier)
		upgrade_stats_array.append(upgrade_stats)

func read_savefile() -> void:
	if !FileAccess.file_exists(PATH_SAVE):
		print("Savefile not found")
		return
	
	# Read data from file
	var file = FileAccess.open(PATH_SAVE, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	# Get dictionaries from file
	var player_stats_dict = data[0]
	var curr_enemy_dict = data[1]
	var upgrade_stats_dicts = data[2]
	
	# Convert dictionaries to objects
	player_stats = PlayerStats.from_dict(player_stats_dict)
	curr_enemy = Enemy.from_dict(curr_enemy_dict) if curr_enemy_dict else null
	
	for upgrade_stats_dict in upgrade_stats_dicts:
		upgrade_stats_array.append(UpgradeStats.from_dict(upgrade_stats_dict))

func save_savefile() -> void:
	# Convert objects to dictionaries
	var player_stats_dict
	if(player_stats):
		player_stats_dict = player_stats.to_dict()
	else: 
		player_stats_dict = null 
	
	var curr_enemy_dict
	if(curr_enemy):
		curr_enemy_dict = curr_enemy.to_dict()
	else:
		curr_enemy_dict = null
	
	var upgrade_stats_dict = []
	for upgrade_stats in upgrade_stats_array:
		upgrade_stats_dict.append(upgrade_stats.to_dict())
	
	# Save dictionaries
	var file = FileAccess.open(PATH_SAVE, FileAccess.WRITE)
	
	file.store_var([
		player_stats_dict,
		curr_enemy_dict,
		upgrade_stats_dict
	])
	
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
	var enemy_dicts = JSON.parse_string(file.get_as_text()).enemies
	
	for enemy_dict in enemy_dicts:
		_enemies.append(Enemy.from_dict(enemy_dict))
	
	file.close()

func get_enemy(id: int) -> Enemy:
	return _enemies[id - 1].duplicate()

func read_stages() -> void:
	if(!FileAccess.file_exists(PATH_STAGES)):
		print("Stages file not found")
		return
	
	var file = FileAccess.open(PATH_STAGES, FileAccess.READ)
	_stages = JSON.parse_string(file.get_as_text()).stages
	file.close()

# TODO: Add type after adding Stage class
func get_stage(id: int):
	return _stages[id - 1].duplicate()

func read_upgrades() -> void:
	if(!FileAccess.file_exists(PATH_UPGRADES)):
		print("Upgrades file not found")
		return
		
	var file = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	var upgrade_dicts = JSON.parse_string(file.get_as_text()).upgrades
	
	for upgrade_dict in upgrade_dicts:
		_upgrades.append(Upgrade.from_dict(upgrade_dict))
	
	file.close()

func read_skills() -> void:
	if(!FileAccess.file_exists(PATH_SKILLS)):
		print("Skills file not found")
		return
		
	var file = FileAccess.open(PATH_SKILLS, FileAccess.READ)
	var skill_dicts = JSON.parse_string(file.get_as_text()).skills
	
	for skill_dict in skill_dicts:
		_skills.append(Skill.from_dict(skill_dict))
	
	file.close()

func get_upgrade(id: int) -> Upgrade:
	return _upgrades[id - 1].duplicate()
