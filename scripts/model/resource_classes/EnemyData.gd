extends Resource
class_name EnemyData

@export_category("Info")
@export var id: int
@export var name: String
@export var texture: Texture2D

@export_category("Stats")
@export var damage: int
@export var health: int
@export var defense: int

@export_category("Rewards")
@export var gold_reward: int
@export var xp_reward: int
@export var loot_table: Array[LootEntry] = []
