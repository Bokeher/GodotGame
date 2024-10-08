extends Label

var time_passed = 0

func _ready():
	update_player_health()
	$"..".update_player_health_bar()

func update_player_health():
	$".".text = str(Global.player_stats.health) + " HP"

func _process(delta):
	time_passed += delta
	if time_passed >= 1.0:
		if(!Global.curr_enemy):
			time_passed = 0
			return
		
		Global.player_stats.health -= Global.curr_enemy.damage
		update_player_health()
		$"..".update_player_health_bar()
		
		if(Global.player_stats.health <= 0):
			print("ded")
		
		time_passed = 0
