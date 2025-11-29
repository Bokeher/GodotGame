extends Resource
class_name EnemyData

@export_category("Info")
@export var id: int
@export var name: String
@export var image_path: String

@export_category("Stats")
@export var damage: int
@export var health: int

@export_category("Rewards")
@export var gold_reward: int
@export var xp_reward: int
@export var loot_table: Array[LootEntry] = []
