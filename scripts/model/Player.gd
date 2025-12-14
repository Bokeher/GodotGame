class_name Player

const BASE_ATTACK_INTERVAL: float = 0.5
const BASE_ATTACK_DAMAGE: int = 1
const BASE_MAX_HEALTH: int = 10

var max_health: int
var health: int
var regen: int
var regen_time: float

var attack_interval: float # only var that is not saved
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
var skill_points: int

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
	_level: int = 1,
	_skill_points: int = 0,
	_attack_interval: float = BASE_ATTACK_INTERVAL,
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
	skill_points = _skill_points
	attack_interval = _attack_interval

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
		"level": level,
		"skill_points": skill_points
	}

# Used in reading from savefile
static func from_dict(data: Dictionary) -> Player:
	return Player.new(
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
		data.get("level", 1),
		data.get("skill_points", 0)
	)

func calc_respawn_time() -> float:
	return 1.1 - speed * 0.1

func calc_crit_chance() -> float:
	return crit_chance * 100

func calc_gold_mult() -> int:
	return luck + 99

func calc_xp_mult() -> int:
	return wisdom + 99

func add_xp(amount: int) -> bool:
	var required_xp = 100
	var leveled_up = false
	
	xp += amount
	
	while(xp > required_xp):
		xp -= required_xp
		level += 1
		skill_points += 1
		leveled_up = true
	
	return leveled_up

func receive_damage(damage_: int) -> void:
	health -= max(0, damage_)

static func calc_attack_interval() -> float:
	var base: float = Player.BASE_ATTACK_INTERVAL
	var mult: float = 1.00
	
	if Global.selected_class_id == Enums.Classes.WARRIOR:
		for skill in Global.skills:
			if skill.level == 0:
				continue
			
			if skill.id == Enums.WarriorSkillIds.HEAVY_BLOW:
				# this increases base because higher base value means lower attack speed
				base *= Global.warrior_class.get_heavy_blow_attack_speed_penalty_multiplier()
			elif skill.id == Enums.WarriorSkillIds.BERSERK:
				if Global.player.health <= 0.4 * Global.player.max_health:
					#TODO: decide if all skills should provide multiplicitve or additive bonuses
					# Substracting because lower value means higher attack speed 
					mult -= Global.warrior_class.get_berserk_attack_speed_bonus()
	
	return base * mult

static func calc_attack_damage() -> int:
	var base: float = Player.BASE_ATTACK_DAMAGE
	var mult: float = 1.00
	
	for item_id in Global.equipped_items:
		if item_id == -1: 
			continue
		
		if item_id == Enums.ItemIds.RING_OF_MINOR_DAMAGE:
			base += 1
		elif item_id == Enums.ItemIds.RING_OF_DAMAGE:
			base += 2
		elif item_id == Enums.ItemIds.RING_OF_MAJOR_DAMAGE:
			base += 3
	
	if Global.selected_class_id == Enums.Classes.WARRIOR:
		# rewrite this with Global.skills[] instead of checking all skills
		for skill in Global.skills:
			if skill.level == 0:
				continue
			
			if skill.id == Enums.WarriorSkillIds.HEAVY_BLOW:
				mult *= Global.warrior_class.get_heavy_blow_attack_damage_multipier()
			elif skill.id == Enums.WarriorSkillIds.ADRENALINE:
				#TODO: Decide if this should be additive or multiplicitive
				mult *= Global.warrior_class.get_adrenaline_damage_multiplier()
			elif skill.id == Enums.WarriorSkillIds.BLOODRAGE and Global.warrior_class.bloodrage_active:
				mult *= Global.warrior_class.get_bloodrage_damage_mult()
	elif Global.selected_class_id == Enums.Classes.LUCKSWORN:
		for skill in Global.skills:
			if skill.level == 0:
				continue
			
			match skill.id:
				Enums.LuckswornSkillIds.GAMBLERS_FATE:
					mult *= Global.lucksworn_class.get_gamblers_fate_damage_multiplier()
				Enums.LuckswornSkillIds.EXTREME_LUCK:
					mult *= Global.lucksworn_class.get_extreme_luck_damage_multiplier()
				Enums.LuckswornSkillIds.GUARANTEED_WIN:
					mult *= Global.lucksworn_class.get_guaranteed_win_damage_mult()
				Enums.LuckswornSkillIds.LUCKY_STRIKE:
					mult *= Global.lucksworn_class.get_lucky_strike_damage_multiplier()
				Enums.LuckswornSkillIds.LUCKIER_STRIKE:
					mult *= Global.lucksworn_class.get_luckier_strike_damage_multiplier()
				Enums.LuckswornSkillIds.BAD_LUCK:
					mult *= Global.lucksworn_class.get_bad_luck_damage_multiplier()
				_:
					pass
	
	return floor(base * mult)

static func calc_max_health() -> int:
	var base: int = Player.BASE_MAX_HEALTH
	
	for item_id in Global.equipped_items:
		if item_id == -1: 
			continue
		
		if item_id == Enums.ItemIds.LEATHER_JACKET:
			base += 10
	
	return base
