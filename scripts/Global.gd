extends Node

var debug_mode: bool = true

# File paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/jsons/enemies.json"
const PATH_STAGES: String = "res://assets/jsons/stages.json"
const PATH_UPGRADES: String = "res://assets/jsons/upgrades.json"
const PATH_SKILLS: String = "res://assets/jsons/skills.json"
const PATH_ITEMS: String = "res://assets/jsons/items.json"
const PATH_CLASSES_DIR: String = "res://assets/jsons/classes/"
const PATH_RESOURCES: String = "res://assets/resources/"
const PATH_RESOURCES_STATUSES: String = PATH_RESOURCES + "statuses/"

# Used to precisely set postion of Popups based on position of MainTabContainer 
const MAIN_TAB_CONTAINER_POSITION: Vector2i = Vector2i(580, 0)

# Resources [read from json files]
var stages = []
var enemies: Array[Enemy] = []
var upgrades: Array[Upgrade] = []
var items: Array[Item] = []
var skills: Array[Skill] = []
var statuses: Dictionary = {}

# State vars
var player_stats: Player = Player.new()
var pet: Pet = Pet.new(-1, "", "", "")
var bestiary: Bestiary = Bestiary.new()
var curr_enemy: Enemy
var curr_stage = null
# Key is id of item, value is amount
var inventory: Dictionary = {} 
# Holds ids of equipped items [Order based on EquippedSlot ids]
var equipped_items: Array[int] = [0, 0, 0]

# UI tracking states
var curr_bestiary_enemy_id: int = -1
var selected_class_id: int = Enums.Classes.LUCKSWORN
var inventory_filter: int = Enums.InventoryType.NONE
var selected_equip_slot_id: int = -1
var last_selected_equip_slot_id: int = -1

# Process timers
const PROCESS_AUTO_SAVE_INTERVAL: float = 5.0
const PROCESS_CALC_INTERVAL: float = 0.5
var process_auto_save_timer: float = 0.0
var process_calc_timer: float = 0.0

# Skill specific tracking
var kensei_class := KenseiClass.new()
var warrior_class := WarriorClass.new()
var lucksworn_class := LuckswornClass.new()

var saveManager: SaveManager = SaveManager.new()

func _ready() -> void:
	# Read all json files
	read_stages()
	read_enemies()
	read_items()
	
	# Read resources
	read_statuses()
	
	saveManager.read()
	
	# Read from json when there are no instances of them
	#if(skills.is_empty()): 
	read_skills()
	if(upgrades.is_empty()): 
		read_upgrades()
	
	# Set curr_stage to max reached stage
	curr_stage = stages[player_stats.max_stage_reached - 1]
	
	if(!curr_enemy):
		curr_enemy = get_enemy(1)
	
	player_stats.attack_interval = calc_attack_interval()

func read_statuses() -> void:
	statuses.clear()
	for res in load_resources_from_folder(PATH_RESOURCES_STATUSES):
		if res is StatusEffect:
			statuses[res.id] = res

func get_status(id: int) -> StatusEffect:
	return statuses.get(id)

# Save on exit
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveManager.save()

func _process(delta) -> void:
	process_calc_timer += delta
	if process_calc_timer >= PROCESS_CALC_INTERVAL:
		player_stats.attack_interval = calc_attack_interval()
		player_stats.damage = calc_attack_damage()
		player_stats.max_health = calc_max_health()
		
		process_calc_timer = 0.0
		
		var stats := get_node("/root/Game/MainTabContainer/StatsPanel/Stats")
		if stats:
			stats.update_stats()
	
	# Auto save 
	process_auto_save_timer += delta
	if process_auto_save_timer >= PROCESS_AUTO_SAVE_INTERVAL:
		saveManager.save()
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
	var PATH: String = Enums.get_class_json_path(selected_class_id)
	
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

func calc_attack_interval() -> float:
	var base: float = Player.BASE_ATTACK_INTERVAL
	var mult: float = 1.00
	
	if selected_class_id == Enums.Classes.WARRIOR:
		for skill in skills:
			if skill.level == 0:
				continue
			
			if skill.id == Enums.WarriorSkillIds.HEAVY_BLOW:
				# this increases base because higher base value means lower attack speed
				base *= warrior_class.get_heavy_blow_attack_speed_penalty_multiplier()
			elif skill.id == Enums.WarriorSkillIds.BERSERK:
				if player_stats.health <= 0.4 * player_stats.max_health:
					#TODO: decide if all skills should provide multiplicitve or additive bonuses
					# Substracting because lower value means higher attack speed 
					mult -= warrior_class.get_berserk_attack_speed_bonus()
	
	return base * mult

func calc_attack_damage() -> int:
	var base: float = Player.BASE_ATTACK_DAMAGE
	var mult: float = 1.00
	
	for item_id in equipped_items:
		if item_id == -1: 
			continue
		
		if item_id == Enums.ItemIds.RING_OF_MINOR_DAMAGE:
			base += 1
		elif item_id == Enums.ItemIds.RING_OF_DAMAGE:
			base += 2
		elif item_id == Enums.ItemIds.RING_OF_MAJOR_DAMAGE:
			base += 3
	
	if selected_class_id == Enums.Classes.WARRIOR:
		# rewrite this with Global.skills[] instead of checking all skills
		for skill in skills:
			if skill.level == 0:
				continue
			
			if skill.id == Enums.WarriorSkillIds.HEAVY_BLOW:
				mult *= warrior_class.get_heavy_blow_attack_damage_multipier()
			elif skill.id == Enums.WarriorSkillIds.ADRENALINE:
				#TODO: Decide if this should be additive or multiplicitive
				mult *= warrior_class.get_adrenaline_damage_multiplier()
			elif skill.id == Enums.WarriorSkillIds.BLOODRAGE and warrior_class.bloodrage_is_active:
				mult *= warrior_class.get_bloodrage_damage_mult()
	elif selected_class_id == Enums.Classes.LUCKSWORN:
		for skill in skills:
			if skill.level == 0:
				continue
			
			match skill.id:
				Enums.LuckswornSkillIds.GAMBLERS_FATE:
					mult *= lucksworn_class.get_gamblers_fate_damage_multiplier()
					
				Enums.LuckswornSkillIds.EXTREME_LUCK:
					if lucksworn_class.check_extreme_luck():
						mult *= lucksworn_class.get_extreme_luck_damage_multiplier()
					
				Enums.LuckswornSkillIds.GUARANTEED_WIN:
					if lucksworn_class.should_guaranteed_win_proc():
						mult *= lucksworn_class.get_guaranteed_win_damage_mult()
					
				Enums.LuckswornSkillIds.LUCKY_STRIKE:
					if lucksworn_class.check_lucky_strike():
						mult *= lucksworn_class.get_lucky_strike_damage_multiplier()
					
				Enums.LuckswornSkillIds.LUCKIER_STRIKE:
					if lucksworn_class.check_luckier_strike():
						mult *= lucksworn_class.get_luckier_strike_damage_multiplier()
						
				Enums.LuckswornSkillIds.BAD_LUCK:
					if lucksworn_class.check_bad_luck():
						mult *= lucksworn_class.get_bad_luck_damage_multiplier()
						
				_:
					pass
	
	return floor(base * mult)

func calc_max_health() -> int:
	var base: int = Player.BASE_MAX_HEALTH
	
	for item_id in equipped_items:
		if item_id == -1: 
			continue
		
		if item_id == Enums.ItemIds.LEATHER_JACKET:
			base += 10
	
	return base

func hasItemDroppedFromEnemy(_item_id: int, _enemy_id: int) -> bool:
	var bestiary_entry: BestiaryEntry = Global.bestiary.get_entry(_enemy_id)
	if bestiary_entry == null:
		return false
	
	var drops: Dictionary = bestiary_entry.items_dropped
	
	return drops.has(_item_id)

func load_resources_from_folder(path: String) -> Array:
	var resources: Array = []
	var dir := DirAccess.open(path)
	
	if dir == null:
		push_error("Cant open dir: %s" % path)
		return resources
	
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var res_path = path.path_join(file_name)
				var res = load(res_path)
				if res:
					resources.append(res)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return resources
