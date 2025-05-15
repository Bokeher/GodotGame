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
	
	deal_damage_to_enemy()
	
	toggle_custom_cursor(true)
	is_cursor_rotating = true
	player_attack_timer.start(Global.attack_interval)
	
	# Early return if enemy is not dead
	if (Global.curr_enemy.health > 0):
		return
	
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
		$"../../MainTabContainer/SkillsPanel/SkillPointsAmount".update_skill_points()
	

func deal_damage_to_enemy() -> void:
	var damage = Global.player_stats.damage
	
	# Check crit
	if(is_critical_hit()):
		$"../../HitEnemySound".change_pitch(true)
		damage *= Global.player_stats.crit_multiplier
	else:
		$"../../HitEnemySound".change_pitch()
	
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
