extends Node
class_name CombatController

@export var base_player_interval: float = 1.0
@export var base_enemy_interval: float = 1.0

var player: PlayerInstance
var enemy: EnemyInstance
var damage_resolver: DamageResolver

var player_attack: AttackController
var enemy_attack: AttackController

func _ready() -> void:
	player_attack = AttackController.new()
	add_child(player_attack)
	
	enemy_attack = AttackController.new()
	add_child(enemy_attack)

func setup(player_: PlayerInstance, enemy_: EnemyInstance, damage_resolver_) -> void:
	player = player_
	enemy = enemy_
	damage_resolver = damage_resolver_
	
	player_attack.base_interval = player.attack_speed_interval
	enemy_attack.base_interval = enemy.enemy_data.attack_interval
	
	player_attack.setup(player, damage_resolver)
	enemy_attack.setup(enemy, damage_resolver)
