extends Node

# File paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/jsons/enemies.json"
const PATH_STAGES: String = "res://assets/jsons/stages.json"
const PATH_UPGRADES: String = "res://assets/jsons/upgrades.json"
const PATH_SKILLS: String = "res://assets/jsons/skills.json"
const PATH_ITEMS: String = "res://assets/jsons/items.json"

# Used to precisely set postion of Popups based on position of MainTabContainer 
const MAIN_TAB_CONTAINER_POSITION = Vector2i(580, 0)

# State vars
var curr_enemy: Enemy
var curr_stage = null
var player_stats: Player = Player.new()

var inventory: Dictionary = {}
# Key is id of item, value is amount

var enemies: Array[Enemy] = []
var stages = []
var upgrades: Array[Upgrade] = []
var skills: Array[Skill] = []
var items: Array[Item] = []
var pet: Pet = Pet.new(-1, "", "", "")

# Auto save vars
const AUTO_SAVE_INTERVAL = 5.0
var auto_save_timer = 0.0

func _ready() -> void:
	# Read all json files
	read_stages()
	read_enemies()
	read_items()
	
	read_savefile()
	
	# Read from json when there are no instances of them
	if(skills.is_empty()): read_skills()
	if(upgrades.is_empty()): read_upgrades()
	
	# Set curr_stage to max reached stage
	curr_stage = stages[player_stats.max_stage_reached - 1]
	
	if(!curr_enemy):
		curr_enemy = get_enemy(1)

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
	var skills_dicts = data[2]
	var upgrades_dicts = data[3]
	inventory = data[4]
	
	# Convert dictionaries to objects
	player_stats = Player.from_dict(player_stats_dict)
	curr_enemy = Enemy.from_dict(curr_enemy_dict) if curr_enemy_dict else null
	
	for skills_dict in skills_dicts:
		skills.append(Skill.from_dict(skills_dict))
	
	for upgrades_dict in upgrades_dicts:
		upgrades.append(Upgrade.from_dict(upgrades_dict))

func save_savefile() -> void:
	# Convert objects to dictionaries
	var player_stats_dict = null
	if(player_stats):
		player_stats_dict = player_stats.to_dict()
	
	var curr_enemy_dict = null
	if(curr_enemy):
		curr_enemy_dict = curr_enemy.to_dict()
	
	var skills_dicts = []
	for skill in skills:
		skills_dicts.append(skill.to_dict())
	
	var upgrdes_dicts = []
	for upgrade in upgrades:
		upgrdes_dicts.append(upgrade.to_dict())
	
	# Save dictionaries
	var file = FileAccess.open(PATH_SAVE, FileAccess.WRITE)
	
	file.store_var([
		player_stats_dict,
		curr_enemy_dict,
		skills_dicts,
		upgrdes_dicts,
		inventory
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
		enemies.append(Enemy.from_dict(enemy_dict))
	
	file.close()

func get_enemy(id: int) -> Enemy:
	return enemies[id - 1].duplicate()

func read_stages() -> void:
	if(!FileAccess.file_exists(PATH_STAGES)):
		print("Stages file not found")
		return
	
	var file = FileAccess.open(PATH_STAGES, FileAccess.READ)
	stages = JSON.parse_string(file.get_as_text()).stages
	file.close()

func read_upgrades() -> void:
	if(!FileAccess.file_exists(PATH_UPGRADES)):
		print("Upgrades file not found")
		return
		
	var file = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	var upgrade_dicts = JSON.parse_string(file.get_as_text()).upgrades
	
	upgrades = []
	for upgrade_dict in upgrade_dicts:
		upgrades.append(Upgrade.from_dict(upgrade_dict))
	
	file.close()

func read_skills() -> void:
	if(!FileAccess.file_exists(PATH_SKILLS)):
		print("Skills file not found")
		return
		
	var file = FileAccess.open(PATH_SKILLS, FileAccess.READ)
	var skill_dicts = JSON.parse_string(file.get_as_text()).skills
	
	skills = []
	for skill_dict in skill_dicts:
		skills.append(Skill.from_dict(skill_dict))
	
	file.close()

func read_items() -> void:
	if(!FileAccess.file_exists(PATH_ITEMS)):
		print("Items file not found")
		return
		
	var file = FileAccess.open(PATH_ITEMS, FileAccess.READ)
	var items_dicts = JSON.parse_string(file.get_as_text()).items
	
	items = []
	for items_dict in items_dicts:
		items.append(Item.from_dict(items_dict))
	
	file.close()
