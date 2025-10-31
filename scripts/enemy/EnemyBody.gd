extends TextureButton

@onready var player_attack_timer: Timer = $"../../PlayerAttackTimer"
@onready var custom_cursor = $"../../CustomCursor"

# Flag to check if rotation is in progress
var is_cursor_rotating = false  

var cursor_paths = [
	"res://assets/sprites/cursors/cursor_warrior.png",
	"res://assets/sprites/cursors/cursor_umbral_reaver.png",
	"res://assets/sprites/cursors/cursor_lucksworn.png",
	"res://assets/sprites/cursors/cursor_kensei.png"
]

func _ready() -> void:
	update_enemy_sprite()
	
	# Load correct cursor depending on class
	custom_cursor.texture = load(cursor_paths[Global.selected_class_id])
	
	# Hide custom cursor
	toggle_custom_cursor(false)

func _process(_delta):
	# Follow the mouse position
	custom_cursor.position = get_viewport().get_mouse_position()
	
	# Show custom cursor when pointing at enemy AND hide when not pointing
	var is_enemy_targeted: bool = is_cursor_pointing_at_enemy()
	toggle_custom_cursor(is_enemy_targeted)
	
	# Rotate the cursor sprite if it's in rotation mode
	if is_cursor_rotating:
		var time_elapsed = player_attack_timer.wait_time - player_attack_timer.time_left
		# Calculate the rotation angle based on the elapsed time
		var rotation_amount = (time_elapsed / player_attack_timer.wait_time) * 360
		custom_cursor.rotation_degrees = rotation_amount
	

func _pressed() -> void:
	# Early return if not ready for attack
	if !player_attack_timer.is_stopped():
		return
	
	if is_enemy_hit():
		var damage = Global.player_stats.damage
		# Check crit
		if(is_critical_hit()):
			$"../../HitEnemySound".change_pitch(true)
			damage *= Global.player_stats.crit_multiplier
		else:
			$"../../HitEnemySound".change_pitch()
		
		deal_damage_to_enemy(damage)
	
	toggle_custom_cursor(true)
	is_cursor_rotating = true
	player_attack_timer.start(Global.player_stats.attack_interval)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Kensei_SwordPath"):
		if Global.selected_class_id != Enums.Classes.KENSEI:
			return
		
		if !Global.curr_enemy:
			return
		
		var lines = $"../KenseiLines"
		if lines.get_children().size() == 0:
			return
		
		var swords_path_timer: Timer = $"../../KenseiSpecific/SwordsPathTimer"
		if !swords_path_timer.is_stopped():
			return
		
		swords_path_timer.start()
		
		var sword_path = Global.skills[Enums.KenseiSkillIds.SWORDS_PATH - 1]
		if sword_path.level == 0:
			return
		
		$"../../KenseiSpecific/SwordsPathFinisherAttack".reset_pitch()
		# Turn all lines red and play sound
		for line: Line2D in lines.get_children():
			line.default_color = Color.RED
			await get_tree().create_timer(0.05).timeout
			$"../../KenseiSpecific/SwordsPathFinisherAttack".play_with_increased_pitch()
		
		await get_tree().create_timer(0.3).timeout # wait 0.3 seconds
		
		var damage: int = get_swords_path_damage()
		
		# Remove all lines
		for line: Line2D in lines.get_children():
			lines.remove_child(line)
		# TODO: Add here kensei finisher sound / change other Sword's Path specifics
		Global.kensei_class.swords_path_lines_amount = 0
		
		deal_damage_to_enemy(damage)
		

func get_swords_path_damage() -> int:
	var line_amount: int = Global.kensei_class.swords_path_lines_amount
	var base_damage: int = Global.player_stats.damage
	
	var patience: Skill = Global.skills[Enums.KenseiSkillIds.PATIENCE - 1]
	var max_stack_amount: int = Global.kensei_class.swords_path_base_max_stacks + patience.level
	
	var sharp_edge: Skill = Global.skills[Enums.KenseiSkillIds.SHARP_EDGE - 1]
	var per_stack_multiplier: float = Global.kensei_class.swords_path_base_damage_multiplier + Global.kensei_class.sharp_edge_values[sharp_edge.level]
	
	var stack_multiplier = 1 + (min(line_amount, max_stack_amount) * per_stack_multiplier)
	
	return base_damage * line_amount * stack_multiplier

func is_enemy_hit() -> bool:
	var should_hit: bool = true
	if Global.selected_class_id == Enums.Classes.KENSEI:
		should_hit = handle_kensei_skills()
	elif Global.selected_class_id == Enums.Classes.LUCKSWORN:
		should_hit = handle_lucksworn_skills()
	return should_hit

func handle_kensei_skills() -> bool:
	var sword_path = Global.skills[Enums.KenseiSkillIds.SWORDS_PATH - 1]
	if sword_path.level == 0:
		return true
	
	var enemy_size: Vector2 = $".".get_minimum_size()
	var enemy_scale: Vector2 = $".".scale
	var enemy_width: float = enemy_size[0]
	var enemy_heigth: float = enemy_size[1]
	
	var line := Line2D.new()
	line.width = 2
	
	# FIRST POINT: left wall / top wall
	var left_top_point: Vector2
	
	var left := randi_range(0, 1)
	if left: # left wall
		var random_point := randi_range(0, int(enemy_heigth * enemy_scale[0]))
		left_top_point = Vector2(0, random_point)
	else:    # top wall
		var random_point := randi_range(0, int(enemy_width * enemy_scale[1]))
		left_top_point = Vector2(random_point, 0)
	
	line.add_point(left_top_point)
	
	# SECOND POINT: right wall / bottom wall
	var right_bot_point: Vector2
	
	var right := randi_range(0, 1)
	if right: # right wall
		var random_point := randi_range(0, int(enemy_heigth * enemy_scale[1]))
		right_bot_point = Vector2(enemy_width * enemy_scale[0], random_point)
	else:     # bottom wall
		var random_point := randi_range(0, int(enemy_width * enemy_scale[1]))
		right_bot_point = Vector2(random_point, enemy_heigth * enemy_scale[1])
	
	line.add_point(right_bot_point)
	
	Global.kensei_class.swords_path_lines_amount += 1
	$"../KenseiLines".add_child(line)
	
	# PLAY HIT SOUND
	$"../../KenseiSpecific/SwordsPathHitSound".play_with_random_pitch()
	
	# MASTER'S TEMPO
	var reached_max_stacks: bool = Global.kensei_class.increase_masters_tempo()
	if reached_max_stacks:
		is_enemy_hit()
		# Decrease stack amount to prevent increase on another is_enemy_hit()
		Global.kensei_class.masters_tempo_curr_stack_amount -= 1
		
		var improved_tempo: Skill = Global.skills[Enums.KenseiSkillIds.IMPROVED_TEMPO - 1]
		if Global.kensei_class.process_improved_tempo(improved_tempo.level):
			is_enemy_hit()
			# Decrease stack amount to prevent increase on another is_enemy_hit()
			Global.kensei_class.masters_tempo_curr_stack_amount -= 1
		
	
	# SWORDMASTER'S INSTINCT
	if Global.skills[Enums.KenseiSkillIds.SWORDMASTERS_INSTINCT - 1].level == 0:
		return false
	
	var show_skull: bool = false
	
	var enemy_hp: int = Global.curr_enemy.health
	if enemy_hp * Global.kensei_class.get_instinct_threshold() <= get_swords_path_damage():
		show_skull = true
	$"../../KenseiSpecific/SwordsmasterInstinctSkull".visible = show_skull
	
	return false

func handle_lucksworn_skills() -> bool:
	var gamblers_fate: Skill = Global.skills[Enums.LuckswornSkillIds.GAMBLERS_FATE - 1]
	
	if gamblers_fate.level == 0:
		return true
	
	# LUCKY STRIKE
	Global.lucksworn_class.roll_lucky_strike()
	
	# LUCKIER STRIKE
	Global.lucksworn_class.roll_luckier_strike()
	
	# GUARANTEED WIN
	var guaranteed_win: Skill = Global.skills[Enums.LuckswornSkillIds.GUARANTEED_WIN - 1]
	if guaranteed_win.level > 0:
		var should_hit: bool = Global.lucksworn_class.increase_guaranteed_win()
		if should_hit:
			return true
	
	var hit_chance: float = Global.lucksworn_class.get_hit_chance()
	var enemy_is_hit: bool = randf() < hit_chance
	
	if not enemy_is_hit:
		Global.lucksworn_class.roll_sworn_dice()
	
	Global.lucksworn_class.set_bad_luck(enemy_is_hit)
	
	var lucksworn_save: bool = Global.lucksworn_class.check_sworn_dice_save_throw()
	var bad_luck_save: bool = Global.lucksworn_class.check_bad_luck()
	
	if enemy_is_hit or lucksworn_save or bad_luck_save:
		if !bad_luck_save:
			Global.lucksworn_class.increase_gamblers_fate()
		
		return true
	
	Global.lucksworn_class.reset_gamblers_fate()
	return false 

func deal_damage_to_enemy(damage: int) -> void:
	if !Global.curr_enemy or damage <= 0:
		return
	
	$"../../HitEnemySound".play()
	
	Global.curr_enemy.health -= damage
	
	# WARRIOR SKILL: ADRENALINE
	Global.warrior_class.adrenalineStacks = 0
	
	$"..".update_enemy()
	
	if (Global.curr_enemy.health <= 0):
		handle_enemy_death()

func handle_enemy_death() -> void:
	if Global.selected_class_id == Enums.Classes.WARRIOR:
		Global.warrior_class.increase_overkill_damage(abs(Global.curr_enemy.health))
		$"../../WarriorSpecific/BloodrageTimer".start_timer()
	
	var enemy_id = Global.curr_enemy.id
	
	var entry: BestiaryEntry = Global.bestiary.get_entry(enemy_id)
	if(!entry): 
		entry = Global.bestiary.set_entry(enemy_id, BestiaryEntry.new(0, {}))
	
	entry.add_slay()
	
	# Reset regen timer to prevent instaheal on killing enemy
	$"../../PlayerHealthBar/PlayerHealth".regen_time_passed = 0
	
	# Give rewards for defeating enemy
	Global.player_stats.gold += Global.curr_enemy.gold_reward
	var leveled_up: bool = Global.player_stats.add_xp(Global.curr_enemy.xp_reward)
	
	# Drop items
	var dropped_item_ids = Global.curr_enemy.get_loot()
	for item_id: int in dropped_item_ids:
		entry.add_item_dropped(item_id)
		Global.inventory[item_id] = Global.inventory.get(item_id, 0) + 1
	
	# Make enemy disapear
	Global.curr_enemy = null
	$"../../KenseiSpecific/SwordsmasterInstinctSkull".visible = false
	$"..".hide_enemy()
	
	# Start filling bar to show progress of finding new enemy
	$"../HealthBar".start_filling()
	
	# Update all related elements
	$"..".update_enemy()
	$"../../PlayerXpBar".update_xp_bar()
	$"../../MainTabContainer/StatsPanel/Stats".update_stats()
	$"../../MainTabContainer/UpgradesPanel/GoldAmount".update_gold()
	$"../../MainTabContainer/InventoryPanel/Inventory".update_inventory()
	$"../../MainTabContainer/BestiaryPanel/Bestiary".update_bestiary()
	if(leveled_up):
		$"../../MainTabContainer/SkillsPanel/SkillTree".update_skill_points()

func update_enemy_sprite() -> void:
	if(!Global.curr_enemy):
		$".".texture_normal = null
		return
	
	$".".texture_normal = load(Global.curr_enemy.image_path)

func is_critical_hit() -> bool:
	return randf() <= Global.player_stats.crit_chance

func is_cursor_pointing_at_enemy() -> bool:
	var enemy_pos = $"..".position + $".".position
	var enemy_size = $".".size
	var enemy_scale = $".".scale
	var cursor_pos = custom_cursor.position
	
	return (
		cursor_pos.x < (enemy_pos + (enemy_size * enemy_scale)).x &&
		cursor_pos.x > enemy_pos.x &&
		cursor_pos.y > enemy_pos.y &&
		cursor_pos.y < (enemy_pos + (enemy_size * enemy_scale)).y
	)

func _on_player_attack_timer_timeout():
	is_cursor_rotating = false

func toggle_custom_cursor(show_custom_cursor: bool) -> void:
	if show_custom_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		custom_cursor.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		custom_cursor.visible = false
