extends UnitInstance
class_name PlayerInstance

@export var base_stats: GeneralBaseStats

@export_category("Defensive")
@export var defense: int
@export var health_regen: float

@export_category("Offensive")
@export var damage: int
@export var attack_speed_interval: float
@export var crit_chance: float
@export var crit_damage_multiplier: float

@export_category("Inventory")
@export var inventory: Inventory
@export var gold: int

@export_category("Progress")
@export var level: int
@export var xp: int
@export var max_stage_reached: int
@export var skill_points: int

var base_xp_amount: int = 100
var on_level_up_xp_multiplier: float = 0.2

var attack_timer: Timer

signal stats_changed
signal xp_changed

func _init(base_stats_: GeneralBaseStats) -> void:
	base_stats = base_stats_
	if base_stats:
		load_base_stats()
	
	attack_timer = build_attack_timer()

func build_attack_timer() -> Timer:
	var timer = Timer.new()
	
	timer.wait_time = attack_speed_interval
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(on_attack_cooldown_finished)
	
	return timer

func on_attack_cooldown_finished() -> void:
	print("finshed")

func can_attack() -> bool:
	return attack_timer.is_stopped()

func start_attack_cooldown() -> void:
	attack_timer.start()

func get_damage_reduction(incoming_damage: int) -> int:
	return max(incoming_damage - defense, 1)

func get_attack_damage() -> int:
	var is_crit: bool = randf() < crit_chance
	
	if is_crit:
		return int(damage * crit_damage_multiplier)
	
	return damage

func load_base_stats() -> void:
	max_health = base_stats.base_max_health
	health = max_health
	defense = base_stats.base_defense
	health_regen = base_stats.base_health_regen
	
	damage = base_stats.base_attack_damage
	attack_speed_interval = base_stats.base_attack_interval
	crit_chance = base_stats.base_crit_chance
	crit_damage_multiplier = base_stats.base_crit_damage_multiplier
	
	gold = 0
	
	level = 1
	xp = 0
	max_stage_reached = 1
	skill_points = 0
	
	inventory = Inventory.new()
	
	stats_changed.emit()

func add_gold(amount: int) -> void:
	gold += amount

func calc_xp_needed(level_: int) -> int:
	return int(pow(1.0 + on_level_up_xp_multiplier, (level_ - 1)) * base_xp_amount)

func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	
	xp += amount
	
	while xp >= calc_xp_needed(level):
		xp -= calc_xp_needed(level)
		level_up()
	
	xp_changed.emit()

func level_up() -> void:
	level += 1
	stats_changed.emit()

func get_xp_str() -> String:
	return "%d / %d" % [xp, calc_xp_needed(level)]
