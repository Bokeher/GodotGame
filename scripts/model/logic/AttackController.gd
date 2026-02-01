extends Node
class_name AttackController

@export var base_interval: float = 1.0
var multiplier: float = 1.0

var source: UnitInstance
var target: UnitInstance
var damage_resolver: DamageResolver
signal attack_cooldown_progress(value: float, max: float)

var timer: Timer
var auto_enabled := false

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_cooldown_finished)
	update_timer()

func _process(delta: float) -> void:
	if timer.is_stopped():
		return
	
	attack_cooldown_progress.emit(timer.wait_time - timer.time_left, timer.wait_time)

func setup(
	source_: UnitInstance,
	damage_resolver_: DamageResolver,
	base_interval_: float = -1.0
) -> void:
	source = source_
	damage_resolver = damage_resolver_
	if base_interval_ > 0:
		base_interval = base_interval_
	update_timer()

func try_attack(target_: UnitInstance) -> bool:
	if not can_attack(target_) or not timer.is_stopped():
		return false
	
	target = target_
	_execute_attack()
	return true

func start_auto(target_: UnitInstance) -> void:
	target = target_
	if not can_attack(target):
		return
	
	auto_enabled = true
	if timer.is_stopped():
		_execute_attack()

func stop_auto() -> void:
	auto_enabled = false
	timer.stop()

func _execute_attack() -> void:
	damage_resolver.deal_damage(source, target)
	timer.start()

func _on_cooldown_finished() -> void:
	if auto_enabled and can_attack(target):
		_execute_attack()
	
	attack_cooldown_progress.emit(timer.wait_time - timer.time_left, timer.wait_time)

func update_timer() -> void:
	if timer:
		timer.wait_time = base_interval / multiplier

func can_attack(target_: UnitInstance) -> bool:
	return (
		source != null
		and target_ != null
		and source.health > 0
		and target_.health > 0
	)
