extends Object
class_name PlayerInstance

@export var player_data: PlayerData

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

@export_category("Inventory")
#var inventory: Inventory
@export var gold: int

@export_category("Progress")
@export var level: int
@export var xp: int
@export var max_stage_reached: int
@export var skill_points: int
