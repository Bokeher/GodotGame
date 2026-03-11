extends Node
class_name CombatController

@export var base_player_interval: float = 1.0
@export var base_enemy_interval: float = 1.0

var player: PlayerInstance
var enemy: EnemyInstance
var damage_resolver: DamageResolver

signal combat_started
signal combat_ended
var in_combat: bool = false

var player_attack: AttackController
var enemy_attack: AttackController

func _ready() -> void:
	player_attack = AttackController.new()
	add_child(player_attack)
	
	enemy_attack = AttackController.new()
	add_child(enemy_attack)

func start_combat() -> void:
	if in_combat:
		return
	
	in_combat = true
	combat_started.emit()
	
	GameManager.regen_timer.stop()
	enemy_attack.start_auto(player)

func end_combat() -> void:
	if not in_combat:
		return
	
	in_combat = false
	combat_ended.emit()
	
	GameManager.regen_timer.start(GameManager.regen_proc_delay)
	enemy_attack.stop_auto()

func force_reset() -> void:
	in_combat = false
	
	enemy_attack.stop_auto()
	
	player_attack.target = null
	enemy_attack.target = null

func setup(player_: PlayerInstance, enemy_: EnemyInstance, damage_resolver_: DamageResolver) -> void:
	player = player_
	enemy = enemy_
	damage_resolver = damage_resolver_
	
	player_attack.base_interval = player.attack_speed_interval
	enemy_attack.base_interval = enemy.enemy_data.attack_interval
	
	player_attack.setup(player, damage_resolver)
	enemy_attack.setup(enemy, damage_resolver)
