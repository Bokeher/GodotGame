extends Node

var debug_mode: bool = true

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
var pet: Pet = Pet.new()
var bestiary: Bestiary = Bestiary.new()
var curr_enemy: Enemy
var curr_stage = null
# Key is id of item, value is amount
var inventory: Dictionary = {} 
# Holds ids of equipped items [Order based on EquippedSlot ids]
var equipped_items: Array[int] = [-1, -1, -1]

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
var dataReader: DataReader = DataReader.new()

func _ready() -> void:
	# Read all json files
	dataReader.read_stages()
	dataReader.read_enemies()
	dataReader.read_items()
	
	# Read resources
	dataReader.read_statuses()
	
	saveManager.read()
	
	# Read from json when there are no instances of them
	#if(skills.is_empty()): 
	dataReader.read_skills()
	if(upgrades.is_empty()): 
		dataReader.read_upgrades()
	
	# Set curr_stage to max reached stage
	curr_stage = stages[player_stats.max_stage_reached - 1]
	
	if(!curr_enemy):
		curr_enemy = get_enemy(1)
	
	player_stats.attack_interval = calc_attack_interval()

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

func get_enemy(id: int) -> Enemy:
	return enemies[id - 1].duplicate()

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
