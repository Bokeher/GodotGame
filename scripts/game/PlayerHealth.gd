extends Label

var time_passed = 0

func _ready():
	update_player_health()
	$"..".update_player_health_bar()

func update_player_health():
	$".".text = str(Global.player_stats.health) + " HP"

func _process(delta):
	time_passed += delta
	
	var attack_time = 1.0
	var remaining_time = attack_time - time_passed
	$"../../Enemy/EnemyAttackTimer".text = str(floor(remaining_time * 10) / 10) + "s"
	
	if time_passed >= attack_time:
		if(!Global.curr_enemy):
			time_passed = 0
			return
		
		$"../../ReceiveDamageSound".change_pitch()
		$"../../ReceiveDamageSound".play()
		
		Global.player_stats.health -= Global.curr_enemy.damage
		update_player_health()
		$"..".update_player_health_bar()
		
		if(Global.player_stats.health <= 0):
			print("ded")
		
		time_passed = 0
