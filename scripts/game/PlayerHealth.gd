extends Label

var time_passed = 0
var regen_time_passed = 0
const ATTACK_TIME = 1.0
const REGEN_TIME = 1.0

func _ready() -> void:
	update_player_health()
	$"..".update_player_health_bar()

func update_player_health() -> void:
	$".".text = str(Global.player_stats.health) + " HP"

func _process(delta) -> void:
	time_passed += delta
	regen_time_passed += delta
	
	var regen_amount = Global.player_stats.regen
	
	var remaining_time = ATTACK_TIME - time_passed
	$"../../Enemy/EnemyAttackTimer".text = str(floor(remaining_time * 10) / 10) + "s"
	
	var health = Global.player_stats.health
	var max_health = Global.player_stats.max_health
	
	if(regen_time_passed >= REGEN_TIME && !Global.curr_enemy):
		Global.player_stats.health = min(max_health, regen_amount + health)
		
		update_player_health()
		$"..".update_player_health_bar()
		regen_time_passed = 0
	
	if time_passed >= ATTACK_TIME:
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
