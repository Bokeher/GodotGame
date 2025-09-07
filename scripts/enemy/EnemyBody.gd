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
	
	# Early return if enemy is not dead
	if (Global.curr_enemy.health > 0):
		return
	
	if Global.selected_class_id == Enums.Classes.WARRIOR:
		for skill in Global.skills:
			if skill.id == Enums.WarriorSkillIds.OVERKILL && skill.level > 0:
				Global.overkill_damage = abs(Global.curr_enemy.health) * skill.level / 2
	
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
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Kensei_SwordPath"):
		if Global.selected_class_id != Enums.Classes.KENSEI:
			return
		var sword_path = Global.skills[Enums.KenseiSkillIds.SWORDS_PATH - 1]
		if sword_path.level > 0:
			var lines = $"../KenseiLines"
			# Turn all lines red and play sound
			for line: Line2D in lines.get_children():
				line.default_color = Color.RED
				await get_tree().create_timer(0.03).timeout
				$"../../HitEnemySound".play_with_random_pitch() # TODO: Change this sound
			
			await get_tree().create_timer(0.3).timeout
			
			var line_amount = lines.get_children().size()
			
			# Remove all lines
			for line: Line2D in lines.get_children():
				lines.remove_child(line)
			# TODO: Add here kensei finisher sound / change other Sword's Path specifics
			
			var damage := Global.player_stats.damage
			var max_stack_amount = 5
			
			damage = damage * line_amount * (1 + min(line_amount, max_stack_amount) * 0.1)
			print(damage)
			
			deal_damage_to_enemy(damage)
		

func is_enemy_hit() -> bool:
	if Global.selected_class_id == Enums.Classes.KENSEI:
		var sword_path = Global.skills[Enums.KenseiSkillIds.SWORDS_PATH - 1]
		if sword_path.level > 0:
			var enemy_pos = $".".position
			var enemy_size = $".".get_minimum_size()
			var enemy_scale = $".".scale
			var enemy_width = enemy_size[0]
			var enemy_heigth = enemy_size[1]
			
			var line = Line2D.new()
			line.width = 2
			
			# FIRST POINT: left wall / top wall
			var left_top_point: Vector2
			
			var left = randi_range(0, 1)
			if left: # left wall
				left_top_point = Vector2(0, randi_range(0, enemy_heigth * enemy_scale[0]))
			else:    # top wall
				left_top_point = Vector2(randi_range(0, enemy_width * enemy_scale[1]), 0)
			
			line.add_point(left_top_point)
			
			# SECOND POINT: right wall / bottom wall
			var right_bot_point: Vector2
			
			var right = randi_range(0, 1)
			if right: # right wall
				right_bot_point = Vector2(enemy_width * enemy_scale[0], randi_range(0, enemy_heigth * enemy_scale[1]))
			else:     # bottom wall
				right_bot_point = Vector2(randi_range(0, enemy_width * enemy_scale[1]), enemy_heigth * enemy_scale[1])
			
			line.add_point(right_bot_point)
			
			
			$"../KenseiLines".add_child(line)
			
			return false
	
	return true

func deal_damage_to_enemy(damage: int) -> void:
	# Play damage dealt sound
	$"../../HitEnemySound".play()
	
	Global.curr_enemy.health -= damage
	$"..".update_enemy()

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
