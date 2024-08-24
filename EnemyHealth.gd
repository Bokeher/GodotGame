extends Label

func _ready():
	update_enemy_health()

func update_enemy_health():
	if(!Global.curr_enemy):
		$".".text = ""
		return
	
	$".".text = str(Global.curr_enemy.health) + " HP"
