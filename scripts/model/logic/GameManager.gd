extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance
var enemy: EnemyInstance
var player: PlayerInstance
var combat_controller: CombatController
var damage_resolver: DamageResolver

@export var enemy_respawn_delay: float = 1.0
var respawn_timer: Timer

@export var regen_proc_delay: float = 1.0
var regen_timer: Timer

signal respawn_progress(value: float, max: float)

signal stage_changed(stage: StageInstance)
signal enemy_changed(enemy: EnemyInstance)

signal enemy_death(enemy: EnemyInstance)
signal player_death(player: PlayerInstance)

func _ready() -> void:
	var max_stage_reached: StageData = StageDatabase.get_by_id(Global.player.max_stage_reached)
	
	stage = StageInstance.new(max_stage_reached)
	enemy = spawn_enemy(stage.get_next_enemy())
	player = PlayerInstance.new(GeneralBaseStats.new())
	
	damage_resolver = DamageResolver.new()
	
	combat_controller = CombatController.new()
	add_child(combat_controller)
	
	respawn_timer = build_respawn_timer()
	regen_timer = build_regen_timer()
	
	setup_combat()

func _process(_delta: float) -> void:
	if respawn_timer.is_stopped():
		return
	
	respawn_progress.emit(
		respawn_timer.wait_time - respawn_timer.time_left,
		respawn_timer.wait_time
	)

func build_regen_timer() -> Timer:
	var timer = Timer.new()
	timer.one_shot = false
	timer.timeout.connect(_on_regen_timeout)
	add_child(timer)
	return timer

func _on_regen_timeout() -> void:
	player.heal_damage(int(player.health_regen))

func build_respawn_timer() -> Timer:
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_respawn_timeout)
	add_child(timer)
	return timer

func _on_respawn_timeout() -> void:
	enemy = spawn_enemy(stage.get_next_enemy())
	enemy_changed.emit(enemy)
	setup_combat()

func sync_stage() -> void:
	stage_changed.emit(stage)

func sync_enemy() -> void:
	enemy_changed.emit(enemy)
	enemy.sync()

func change_to_next_stage() -> void:
	change_stage(stage.stage_data.id + 1)

func change_to_prev_stage() -> void:
	change_stage(stage.stage_data.id - 1)

func change_stage(stage_id: int) -> void:
	if stage.stage_data.id == stage_id:
		return
	
	var new_stage: StageData = StageDatabase.get_by_id(stage_id)
	
	if new_stage == null:
		print("New stage is null")
		return
	
	stage = StageInstance.new(new_stage)
	enemy = spawn_enemy(stage.get_next_enemy())
	
	if combat_controller != null and damage_resolver != null and player != null:
		combat_controller.setup(player, enemy, damage_resolver)
	
	stage_changed.emit(stage)
	enemy_changed.emit(enemy)
	
	setup_combat()

func setup_combat():
	if combat_controller == null or player == null or enemy == null:
		return
	
	combat_controller.force_reset()
	combat_controller.setup(player, enemy, damage_resolver)

func spawn_enemy(enemyData: EnemyData) -> EnemyInstance:
	var enemy_ := EnemyInstance.new(enemyData)
	
	enemy_.died.connect(_on_enemy_died)
	
	return enemy_

func _on_enemy_died(dead_enemy: EnemyInstance) -> void:
	combat_controller.end_combat()
	
	player.inventory.add_items(dead_enemy.get_dropped_loot())
	player.add_gold(dead_enemy.enemy_data.gold_reward)
	player.add_xp(dead_enemy.enemy_data.xp_reward)
	
	enemy_death.emit(dead_enemy)
	enemy = null
	
	enemy_changed.emit(enemy)
	
	respawn_timer.start(enemy_respawn_delay)

func _on_player_died(dead_player: PlayerInstance) -> void:
	combat_controller.on_unit_died()
	player_death.emit(dead_player)
