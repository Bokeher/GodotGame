extends Label

func _ready():
	update_enemy_name()

func update_enemy_name():
	if(!Global.curr_enemy):
		$".".text = ""
		return
	
	$".".text = str(Global.curr_enemy.name)
