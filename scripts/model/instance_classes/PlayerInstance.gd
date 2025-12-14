extends Resource
class_name PlayerInstance

@export var base_stats: GeneralBaseStats

@export_category("Defensive")
@export var max_health: int
@export var health: int
@export var defense: int
@export var health_regen: float

@export_category("Offensive")
@export var damage: int
@export var attack_speed_interval: float
@export var crit_chance: float
@export var crit_damage_multiplier: float
@export var attack_interval: float

@export_category("Inventory")
var inventory: Inventory
@export var gold: int

@export_category("Progress")
@export var level: int
@export var xp: int
@export var max_stage_reached: int
@export var skill_points: int

func _init(base_stats_: GeneralBaseStats) -> void:
	base_stats = base_stats_
	load_base_stats()

func load_base_stats() -> void:
	max_health = base_stats.base_max_health
	health = max_health
	defense = base_stats.base_defense
	health_regen = base_stats.base_health_regen
	
	damage = base_stats.base_attack_damage
	attack_interval = base_stats.base_attack_interval
	crit_chance = base_stats.base_crit_chance
	crit_damage_multiplier = base_stats.base_crit_damage_multiplier
	
	gold = 0
	
	level = 1
	xp = 0
	max_stage_reached = 1
	skill_points = 0
	
	inventory = Inventory.new()
