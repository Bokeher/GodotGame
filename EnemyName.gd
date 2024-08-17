extends Label

func _ready():
	update_enemy_name()

func update_enemy_name():
	$".".text = str(Global.curr_enemy.name)
