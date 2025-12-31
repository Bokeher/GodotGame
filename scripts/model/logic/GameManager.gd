extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance
var enemy: EnemyInstance
var player: PlayerInstance
var combat_manager: CombatManager

signal stage_changed(stage: StageInstance)
signal player_death(player: PlayerInstance)

signal enemy_death(enemy: EnemyInstance)
signal enemy_changed(enemy: EnemyInstance)

func _ready() -> void:
	var max_stage_reached: StageData = StageDatabase.get_by_id(Global.player.max_stage_reached)
	
	stage = StageInstance.new(max_stage_reached)
	enemy = spawn_enemy(stage.get_next_enemy())
	player = PlayerInstance.new(GeneralBaseStats.new())
	combat_manager = CombatManager.new()

func sync() -> void:
	stage_changed.emit(stage)

func change_stage(stage_id: int) -> void:
	if stage.stage_data.id == stage_id:
		return
	
	if enemy:
		enemy.queue_free()
	
	stage = StageInstance.new(StageDatabase.get_by_id(stage_id))
	enemy = spawn_enemy(stage.get_next_enemy())
	
	stage_changed.emit(stage)
	enemy_changed.emit(enemy)

func spawn_enemy(enemyData: EnemyData) -> EnemyInstance:
	var enemy_ := EnemyInstance.new(enemyData)
	
	enemy_.died.connect(_on_enemy_died)
	
	return enemy_

func _on_enemy_died(dead_enemy: EnemyInstance) -> void:
	player.inventory.add_items(dead_enemy.get_dropped_loot())
	player.add_gold(dead_enemy.enemy_data.gold_reward)
	player.add_xp(dead_enemy.enemy_data.xp_reward)
	
	print("enemy died " + dead_enemy.enemy_data.name)
	enemy_death.emit(dead_enemy)
	
