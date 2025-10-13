extends Label

var attack_time_passed = 0
var regen_time_passed = 0

const ATTACK_TIME = 1.0

func _ready() -> void:
	$"..".update_player_health_bar()

func _process(delta) -> void:
	attack_time_passed += delta
	regen_time_passed += delta
	
	var remaining_time = ATTACK_TIME - attack_time_passed
	$"../../Enemy/EnemyAttackTimer".text = str(floor(remaining_time * 10) / 10) + "s"
	
	var regen_time = Global.player_stats.regen_time
	
	if(regen_time_passed >= regen_time && !Global.curr_enemy):
		var regen_amount = Global.player_stats.regen
		var health = Global.player_stats.health
		var max_health = Global.player_stats.max_health
		
		Global.player_stats.health = min(max_health, regen_amount + health)
		
		$"..".update_player_health_bar()
		regen_time_passed = 0
	
	if attack_time_passed >= ATTACK_TIME:
		if(!Global.curr_enemy):
			attack_time_passed = 0
			return
		
		var damage_received: int = Global.curr_enemy.damage
		
		# WARRIOR SKILL: DIAMOND SKIN
		if Global.selected_class_id == Enums.Classes.WARRIOR:
			damage_received -= Global.warrior_class.get_diamondskin_damage_reduction(damage_received)
		
		# WARRIOR SKILL: IRON SKIN
		if Global.selected_class_id == Enums.Classes.WARRIOR:
			damage_received -= Global.warrior_class.get_ironskin_damage_reduction()
		
		# Receive damage
		Global.player_stats.receive_damage(damage_received)
		$"..".update_player_health_bar()
		
		# WARRIOR SKILL: ADRENALINE
		if Global.selected_class_id == Enums.Classes.WARRIOR:
			Global.warrior_class.add_adrenaline_stack()
		
		# Play sound
		$"../../ReceiveDamageSound".change_pitch()
		$"../../ReceiveDamageSound".play()
		
		# Death
		if(Global.player_stats.health <= 0):
			print("ded")
		
		attack_time_passed = 0
