extends Node

# File paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/jsons/enemies.json"
const PATH_STAGES: String = "res://assets/jsons/stages.json"
const PATH_UPGRADES: String = "res://assets/jsons/upgrades.json"
const PATH_SKILLS: String = "res://assets/jsons/skills.json"
const PATH_ITEMS: String = "res://assets/jsons/items.json"
const PATH_CLASSES_DIR: String = "res://assets/jsons/classes/"

const CLASS_PATHS: Array = [
	PATH_CLASSES_DIR + "warrior.json",
	PATH_CLASSES_DIR + "umbral_reaver.json",
	PATH_CLASSES_DIR + "lucksworn.json",
	PATH_CLASSES_DIR + "kensei.json",
]

# Used to precisely set postion of Popups based on position of MainTabContainer 
const MAIN_TAB_CONTAINER_POSITION = Vector2i(580, 0)

# State vars
var curr_enemy: Enemy
var curr_stage = null
var player_stats: Player = Player.new()
var curr_bestiary_enemy_id: int = -1
var selected_class_id: int = Enums.Classes.WARRIOR
var BASE_ATTACK_INTERVAL: float = 0.5

var attack_interval: float = .5

var inventory_filter: int = Enums.InventoryType.NONE
var selected_equip_slot_id: int = -1

var inventory: Dictionary = {}
# Key is id of item, value is amount

# Holds ids of equipped items [Order based on EquippedSlot ids]
var equipped_items: Array[int] = [23, 22, 0]

var enemies: Array[Enemy] = []
var stages = []
var upgrades: Array[Upgrade] = []
var skills: Array[Skill] = []
var items: Array[Item] = []
var pet: Pet = Pet.new(-1, "", "", "")
var bestiary: Bestiary = Bestiary.new()

# Process timers
var process_auto_save_timer: float = 0.0
const PROCESS_AUTO_SAVE_INTERVAL: float = 5.0

var process_calc_timer: float = 0.0
const PROCESS_CALC_INTERVAL: float = 0.5

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
	
	attack_interval = calc_attack_interval()

func read_savefile() -> void:
	if !FileAccess.file_exists(PATH_SAVE):
		push_error("Savefile not found")
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
	var pet_dict = data[5]
	var bestiary_dict = data[6]
	equipped_items = data[7]
	
	# Convert dictionaries to objects
	player_stats = Player.from_dict(player_stats_dict) if player_stats_dict else null
	curr_enemy = Enemy.from_dict(curr_enemy_dict) if curr_enemy_dict else null
	pet = Pet.from_dict(pet_dict) if pet_dict else null
	bestiary = Bestiary.from_dict(bestiary_dict) if bestiary_dict else Bestiary.new()
	
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
	
	var pet_dict = null
	if(pet):
		pet_dict = pet.to_dict()
	
	var bestiary_dict = null
	if(bestiary):
		bestiary_dict = bestiary.to_dict()
	
	# Save dictionaries
	var file = FileAccess.open(PATH_SAVE, FileAccess.WRITE)
	
	file.store_var([
		player_stats_dict,
		curr_enemy_dict,
		skills_dicts,
		upgrdes_dicts,
		inventory,
		pet_dict,
		bestiary_dict,
		equipped_items
	])
	
	file.close()
	print("Saved")

# Save on exit
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_savefile()

func _process(delta) -> void:
	process_calc_timer += delta
	if process_calc_timer >= PROCESS_CALC_INTERVAL:
		attack_interval = calc_attack_interval()
		process_calc_timer = 0.0
	
	# Auto save 
	process_auto_save_timer += delta
	if process_auto_save_timer >= PROCESS_AUTO_SAVE_INTERVAL:
		save_savefile()
		process_auto_save_timer = 0.0

func read_enemies() -> void:
	if(!FileAccess.file_exists(PATH_ENEMIES)):
		push_error("Enemies file not found")
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
		push_error("Stages file not found")
		return
	
	var file = FileAccess.open(PATH_STAGES, FileAccess.READ)
	stages = JSON.parse_string(file.get_as_text()).stages
	file.close()

func read_upgrades() -> void:
	if(!FileAccess.file_exists(PATH_UPGRADES)):
		push_error("Upgrades file not found")
		return
		
	var file = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	var upgrade_dicts = JSON.parse_string(file.get_as_text()).upgrades
	
	upgrades = []
	for upgrade_dict in upgrade_dicts:
		upgrades.append(Upgrade.from_dict(upgrade_dict))
	
	file.close()

func read_skills() -> void:
	var PATH = CLASS_PATHS[selected_class_id]
	
	if(!FileAccess.file_exists(PATH)):
		push_error("Skills file not found")
		return
		
	var file = FileAccess.open(PATH, FileAccess.READ)
	var skill_dicts = JSON.parse_string(file.get_as_text()).skills
	
	skills = []
	for skill_dict in skill_dicts:
		skills.append(Skill.from_dict(skill_dict))
	
	file.close()

func read_items() -> void:
	if(!FileAccess.file_exists(PATH_ITEMS)):
		push_error("Items file not found")
		return
		
	var file = FileAccess.open(PATH_ITEMS, FileAccess.READ)
	var items_dicts = JSON.parse_string(file.get_as_text()).items
	
	items = []
	for items_dict in items_dicts:
		items.append(Item.from_dict(items_dict))
	
	file.close()

func get_class_path(class_type: int) -> String:
	if class_type < 0 or class_type >= CLASS_PATHS.size(): 
		push_error("Provided wrong class_type")
		return ""
	
	return CLASS_PATHS[class_type]

func calc_attack_interval() -> float:
	var base: float = BASE_ATTACK_INTERVAL
	var mult: float = 1.00
	
	if selected_class_id == Enums.Classes.WARRIOR:
		for skill in skills:
			if skill.id == 1 and skill.level > 0: # Heavy Blow
				base += 0.25
			elif skill.id == 3 and skill.level > 0: # Bloodrage
				if player_stats.health < 0.4 * player_stats.max_health:
					mult -= 0.25
	
	return base * mult
