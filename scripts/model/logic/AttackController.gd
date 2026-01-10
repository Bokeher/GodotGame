extends Node
class_name AttackController

@export var base_interval: float = 1.0
var multiplier: float = 1.0

var source: UnitInstance
var target: UnitInstance
var damage_resolver: DamageResolver

var timer: Timer
var enabled: bool = false

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = false
	add_child(timer)
	
	timer.timeout.connect(on_timeout)
	update_timer()

func setup(source_: UnitInstance, target_: UnitInstance, damage_resolver_: DamageResolver) -> void:
	source = source_
	target = target_
	damage_resolver = damage_resolver_

func start() -> void:
	if !can_attack():
		return
	
	enabled = true
	timer.start()

func on_timeout() -> void:
	if !enabled or !can_attack():
		stop()
		return
	
	damage_resolver.deal_damage(source, target)

func update_timer() -> void:
	if timer:
		timer.wait_time = base_interval / multiplier

func stop() -> void:
	enabled = false
	timer.stop()

func can_attack() -> bool:
	return source != null and target != null and source.health > 0 and target.health > 0
	
