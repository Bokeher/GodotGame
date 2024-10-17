extends Label

var time_passed = 0
var regen_time_passed = 0

func _ready() -> void:
	update_player_health()
	$"..".update_player_health_bar()

func update_player_health() -> void:
	$".".text = str(Global.player_stats.health) + " HP"

func _process(delta) -> void:
	time_passed += delta
	regen_time_passed += delta
	
	var attack_time = 1.0
	
	var regen_time = 1.0
	var regen_amount = 1
	
	var remaining_time = attack_time - time_passed
	$"../../Enemy/EnemyAttackTimer".text = str(floor(remaining_time * 10) / 10) + "s"
	
	if(regen_time_passed >= regen_time && $"../../ActionButton".curr_state == 0):
		if(Global.player_stats.health + regen_amount <= Global.player_stats.max_health):
			Global.player_stats.health += regen_amount
		
		update_player_health()
		$"..".update_player_health_bar()
		regen_time_passed = 0
	
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
