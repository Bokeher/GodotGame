extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance
var enemy: EnemyInstance
var player: PlayerInstance
var damage_resolver: DamageResolver

@export var enemy_respawn_delay: float = 1.0
var respawn_timer: Timer
var player_attack_timer: Timer

signal respawn_progress(value: float, max: float)

signal stage_changed(stage: StageInstance)
signal enemy_changed(enemy: EnemyInstance)

signal enemy_death(enemy: EnemyInstance)
signal player_death(player: PlayerInstance)

func _ready() -> void:
	var max_stage_reached: StageData = StageDatabase.get_by_id(Global.player.max_stage_reached)
	
	player_attack_timer = Timer.new()
	add_child(player_attack_timer)
	
	stage = StageInstance.new(max_stage_reached)
	enemy = spawn_enemy(stage.get_next_enemy())
	player = PlayerInstance.new(GeneralBaseStats.new(), player_attack_timer)
	damage_resolver = DamageResolver.new()
	
	respawn_timer = build_respawn_timer()

func _process(_delta: float) -> void:
	if respawn_timer.is_stopped():
		return
	
	respawn_progress.emit(
		respawn_timer.wait_time - respawn_timer.time_left,
		respawn_timer.wait_time
	)

func build_respawn_timer() -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_respawn_timeout)
	add_child(timer)
	return timer

func _on_respawn_timeout() -> void:
	enemy = spawn_enemy(stage.get_next_enemy())
	enemy_changed.emit(enemy)

func sync_stage() -> void:
	stage_changed.emit(stage)

func sync_enemy() -> void:
	enemy_changed.emit(enemy)
	enemy.sync()

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
	
	enemy_death.emit(dead_enemy)
	enemy = null
	
	enemy_changed.emit(enemy)
	
	respawn_timer.start(enemy_respawn_delay)
	
