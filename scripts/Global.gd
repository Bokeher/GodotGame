extends Node

var debug_mode: bool = true

# Used to precisely set postion of Popups based on position of MainTabContainer 
const MAIN_TAB_CONTAINER_POSITION: Vector2i = Vector2i(580, 0)

# Resources [read from json files]
var stages = []
var enemies: Array[Enemy] = []
var upgrades: Array[Upgrade] = []
var skills: Array[Skill] = []
var statuses: Dictionary = {} # id -> Status

# State vars
var player: Player = Player.new()
var pet: Pet = Pet.new()
var bestiary: Bestiary = Bestiary.new()
var curr_enemy: Enemy
var curr_stage = null
var inventory: Dictionary = {} # id -> item_amount
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
	dataReader.read_stages()
	dataReader.read_enemies()
	dataReader.read_statuses()
	
	#saveManager.read()
	
	# Read when there are no instances of them
	#if(skills.is_empty()): 
	dataReader.read_skills()
	if(upgrades.is_empty()): 
		dataReader.read_upgrades()
	
	# Set curr_stage to max reached stage
	curr_stage = stages[player.max_stage_reached - 1]
	
	if(!curr_enemy):
		curr_enemy = Enemy.get_enemy(1)
	
	player.attack_interval = Player.calc_attack_interval()

# Save on exit
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveManager.save()

func _process(delta) -> void:
	# update stats every 'PROCESS_CALC_INTERVAL'
	process_calculations(delta)
	
	# autosave every 'PROCESS_AUTO_SAVE_INTERVAL'
	process_autosave(delta)

func process_calculations(delta) -> void:
	process_calc_timer += delta
	if process_calc_timer >= PROCESS_CALC_INTERVAL:
		player.attack_interval = Player.calc_attack_interval()
		player.damage = Player.calc_attack_damage()
		player.max_health = Player.calc_max_health()
		
		process_calc_timer = 0.0
		
		var stats := get_node("/root/Game/MainTabContainer/StatsPanel/Stats")
		if stats:
			stats.update_stats()

func process_autosave(delta) -> void:
	process_auto_save_timer += delta
	if process_auto_save_timer >= PROCESS_AUTO_SAVE_INTERVAL:
		saveManager.save()
		process_auto_save_timer = 0.0
