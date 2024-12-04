class_name PlayerStats

var max_health: int
var health: int
var regen: int
var regen_time: float

var damage: int
var crit_chance: float
var crit_multiplier: float

var speed: int
var wisdom: int
var luck: int

var gold: int
var max_stage_reached: int

var xp: int
var level: int

func _init(
	_max_health: int = 10, 
	_health: int = 10, 
	_regen: int = 2, 
	_regen_time: float = 1.0,
	_damage: int = 1, 
	_crit_chance: float = 0.0,
	_crit_multiplier: float = 2.0,
	_speed: int = 1, 
	_wisdom: int = 1, 
	_luck: int = 1,
	_gold: int = 0, 
	_max_stage_reached: int = 1,
	_xp: int = 0,
	_level: int = 1
):
	max_health = _max_health
	health = _health
	regen = _regen
	regen_time = _regen_time
	damage = _damage
	crit_chance = _crit_chance
	crit_multiplier = _crit_multiplier
	speed = _speed
	wisdom = _wisdom
	luck = _luck
	gold = _gold
	max_stage_reached = _max_stage_reached
	xp = _xp
	level = _level

# Used in saving
func to_dict() -> Dictionary:
	return {
		"max_health": max_health,
		"health": health,
		"regen": regen,
		"regen_time": regen_time,
		"damage": damage,
		"crit_chance": crit_chance,
		"crit_multiplier": crit_multiplier,
		"speed": speed,
		"wisdom": wisdom,
		"luck": luck,
		"gold": gold,
		"max_stage_reached": max_stage_reached,
		"xp": xp,
		"level": level
	}

# Used in reading from savefile
static func from_dict(data: Dictionary) -> PlayerStats:
	return PlayerStats.new(
		data.get("max_health", 10),
		data.get("health", 10),
		data.get("regen", 2),
		data.get("regen_time", 1.0),
		data.get("damage", 1),
		data.get("crit_chance", 0.0),
		data.get("crit_multiplier", 2.0),
		data.get("speed", 1),
		data.get("wisdom", 1),
		data.get("luck", 1),
		data.get("gold", 0),
		data.get("max_stage_reached", 1),
		data.get("xp", 0),
		data.get("level", 1)
	)

func calc_respawn_time() -> float:
	return 1.1 - speed * 0.1

func calc_crit_chance() -> float:
	return crit_chance * 100

func calc_gold_mult() -> int:
	return luck + 99

func calc_xp_mult() -> int:
	return wisdom + 99

