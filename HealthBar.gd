extends ProgressBar

func _ready():
	set_max_value_healthBar()
	update_healthBar()

func update_healthBar():
	if(!Global.curr_enemy):
		return
	
	$".".value = Global.curr_enemy.health

func set_max_value_healthBar():
	$"../HealthBar".max_value = Global.get_enemy(Global.curr_enemy.id).health
