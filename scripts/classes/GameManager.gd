extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance
var enemy: EnemyInstance

signal stage_changed(stage: StageInstance)
signal player_death(player: PlayerInstance)

signal enemy_death(enemy: EnemyInstance)
signal enemy_changed(enemy: EnemyInstance)

func _ready() -> void:
	var max_stage_reached: StageData = StageDatabase.get_by_id(Global.player.max_stage_reached)
	
	stage = StageInstance.new(max_stage_reached)
	enemy = EnemyInstance.new(stage.get_next_enemy())

func change_stage(stage_id: int) -> void:
	if stage.stage_data.id == stage_id:
		return
	
	if enemy:
		enemy.queue_free()
	
	stage = StageInstance.new(StageDatabase.get_by_id(stage_id))
	enemy = EnemyInstance.new(stage.get_next_enemy())
	
	stage_changed.emit(stage)
	enemy_changed.emit(enemy)
