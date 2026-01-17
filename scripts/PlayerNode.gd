extends Node2D

@onready var player: PlayerInstance = GameManager.player

func _ready() -> void:
	player.stats_changed.connect(on_stats_changed)
	player.xp_changed.connect(on_xp_changed)
	player.health_changed.connect(on_health_changed)
	player.damaged.connect(on_damaged)
	
	player.sync()

func on_damaged(_amount: int) -> void:
	$ReceiveDamageSound.play()

func on_stats_changed() -> void:
	$PlayerHealthBar.max_value = player.max_health

func on_health_changed(_old_health: int, new_health: int) -> void:
	$PlayerHealthBar.value = new_health
	$PlayerHealthBar/PlayerHealth.text = player.get_hp_str()

func on_xp_changed() -> void:
	$PlayerXpBar.value = player.xp
	$PlayerXpBar/PlayerXpProgressLabel.text = player.get_xp_str()
