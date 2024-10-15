extends ProgressBar

func _ready() -> void:
	update_player_health_bar()

func update_player_health_bar() -> void:
	var health = Global.player_stats.health
	var max_hp = Global.player_stats.max_health
	
	$".".value = health
	$".".max_value = max_hp
	
