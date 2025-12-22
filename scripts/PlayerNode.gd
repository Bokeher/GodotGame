extends Node2D

@onready var player: PlayerInstance = GameManager.player

func _ready() -> void:
	player.stats_changed.connect(on_stats_changed)
	
	on_stats_changed()
	on_health_changed()
	on_xp_changed()

func on_stats_changed() -> void:
	$PlayerHealthBar.max_value = player.max_health

func on_health_changed() -> void:
	$PlayerHealthBar.value = player.health
	$PlayerHealthBar/PlayerHealth.text = player.get_hp_str()

func on_xp_changed() -> void:
	$PlayerXpBar.value = player.xp
	$PlayerXpBar/PlayerXpProgressLabel.text = player.get_xp_str()
