extends Label

func _ready() -> void:
	update_enemy_name()

func update_enemy_name() -> void:
	if(!Global.curr_enemy):
		$".".text = ""
		return
	
	$".".text = str(Global.curr_enemy.name)
