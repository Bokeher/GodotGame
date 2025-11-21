extends ProgressBar

func _ready() -> void:
	# Regenerate player health to maximum upon game launch
	Global.player.health = Global.player.max_health
	
	update_player_health_bar()

func update_player_health_bar() -> void:
	var health = Global.player.health
	var max_hp = Global.player.max_health
	
	$".".value = health
	$".".max_value = max_hp
	
	$PlayerHealth.text = str(Global.player.health) + " HP"
