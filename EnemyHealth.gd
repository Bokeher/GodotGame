extends Label

func _ready():
	update_enemy_health()

func update_enemy_health():
	$".".text = str(Global.curr_enemy.health) + " HP"
