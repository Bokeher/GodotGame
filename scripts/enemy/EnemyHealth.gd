extends Label

func _ready() -> void:
	update_enemy_health()

func update_enemy_health() -> void:
	if(!Global.curr_enemy):
		$".".text = ""
		return
	
	$".".text = str(Global.curr_enemy.health) + " HP"
