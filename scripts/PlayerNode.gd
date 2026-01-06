extends Node2D

@onready var player: PlayerInstance = GameManager.player

func _ready() -> void:
	player.stats_changed.connect(on_stats_changed)
	player.xp_changed.connect(on_xp_changed)
	player.health_changed.connect(on_health_changed)
	
	player.sync()

func _process(delta: float) -> void:
	$PlayerAttackCooldown.value = GameManager.player.attack_timer.time_left / GameManager.player.attack_timer.wait_time

func on_stats_changed() -> void:
	$PlayerHealthBar.max_value = player.max_health

func on_health_changed() -> void:
	$PlayerHealthBar.max_value = player.max_health
	$PlayerHealthBar.value = player.health
	$PlayerHealthBar/PlayerHealth.text = player.get_hp_str()

func on_xp_changed() -> void:
	$PlayerXpBar.value = player.xp
	$PlayerXpBar/PlayerXpProgressLabel.text = player.get_xp_str()
