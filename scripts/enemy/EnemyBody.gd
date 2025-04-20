extends TextureButton

@onready var player_attack_timer: Timer = $"../../PlayerAttackTimer"
@onready var cursor = $"../../Cursor"

var rotation_duration = 0.5  # Duration to complete one full rotation (in seconds)
var rotation_timer = 0.0  # Timer to track elapsed time
var is_rotating = false  # Flag to check if rotation is in progress

var cursor_paths = [
	"res://assets/sprites/cursor_warrior.png",
	"res://assets/sprites/cursor_umbral_reaver.png", # sprite missing
	"res://assets/sprites/cursor_lucksworn.png", # sprite missing
	"res://assets/sprites/cursor_kensei.png"
]

func _ready() -> void:
	update_enemy_sprite()
	
	# Load correct cursor depending on class
	cursor.visible = false
	cursor.texture = load(cursor_paths[Global.selected_class_id])

func _process(delta):
	# Follow the mouse position
	cursor.position = get_viewport().get_mouse_position()
	
	# Rotate the cursor sprite if it's in rotation mode
	if is_rotating:
		rotation_timer += delta
		# Calculate the rotation angle based on the elapsed time
		var rotation_amount = (rotation_timer / rotation_duration) * 360
		cursor.rotation_degrees = rotation_amount
		
		# Stop the rotation after the set duration
		if rotation_timer >= rotation_duration:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			cursor.visible = false
			is_rotating = false
		
	

func _pressed() -> void:
	if !player_attack_timer.is_stopped():
		return
	
	# Change cursor
	rotation_timer = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.visible = true
	is_rotating = true
	
	deal_damage()
	
	player_attack_timer.start(Global.attack_interval)
	
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
	$"../../MainTabContainer/BestiaryPanel/Bestiary".update_selected_bestiary()
	if(leveled_up):
		$"../../MainTabContainer/SkillsPanel/SkillPointsAmount".update_skill_points()
	

func deal_damage() -> void:
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
