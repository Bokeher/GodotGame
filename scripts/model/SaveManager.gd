class_name SaveManager

const PATH_SAVE: String = "user://save"

func read() -> void:
	if !FileAccess.file_exists(PATH_SAVE):
		push_error("Savefile not found")
		return
	
	# Read data from file
	var file := FileAccess.open(PATH_SAVE, FileAccess.READ)
	
	if file == null:
		print("ERROR: Failed to load savefile since file is null")
		return
	
	var data: Dictionary = file.get_var()
	file.close()
	
	if data == null:
		print("ERROR: Failed to load savefile since data is null")
		return
	
	# Get dictionaries from file
	var player_stats_dict: Dictionary = data[0]
	var curr_enemy_dict: Dictionary = data[1]
	var skills_dicts: Dictionary = data[2]
	var upgrades_dicts: Dictionary = data[3]
	Global.inventory = data[4]
	var pet_dict: Dictionary = data[5]
	var bestiary_dict: Dictionary = data[6]
	Global.equipped_items = data[7]
	
	# Convert dictionaries to objects
	Global.player = Player.from_dict(player_stats_dict) if player_stats_dict else null
	Global.curr_enemy = Enemy.from_dict(curr_enemy_dict) if curr_enemy_dict else null
	Global.pet = Pet.from_dict(pet_dict) if pet_dict else null
	Global.bestiary = Bestiary.from_dict(bestiary_dict) if bestiary_dict else Bestiary.new()
	
	for skills_dict: Dictionary in skills_dicts:
		Global.skills.append(Skill.from_dict(skills_dict))
	
	for upgrades_dict: Dictionary in upgrades_dicts:
		Global.upgrades.append(Upgrade.from_dict(upgrades_dict))
	

func save() -> void:
	# Convert objects to dictionaries
	var player_stats_dict: Dictionary
	if(Global.player):
		player_stats_dict = Global.player.to_dict()
	
	var curr_enemy_dict: Dictionary
	if(Global.curr_enemy):
		curr_enemy_dict = Global.curr_enemy.to_dict()
	
	var skills_dicts: Array[Dictionary] = []
	for skill in Global.skills:
		skills_dicts.append(skill.to_dict())
	
	var upgrades_dicts: Array[Dictionary] = []
	for upgrade in Global.upgrades:
		upgrades_dicts.append(upgrade.to_dict())
	
	var pet_dict: Dictionary = {}
	if(Global.pet):
		pet_dict = Global.pet.to_dict()
	
	var bestiary_dict: Dictionary = {}
	if(Global.bestiary):
		bestiary_dict = Global.bestiary.to_dict()
	
	# Save dictionaries
	var file: FileAccess = FileAccess.open(PATH_SAVE, FileAccess.WRITE)
	
	file.store_var([
		player_stats_dict,
		curr_enemy_dict,
		skills_dicts,
		upgrades_dicts,
		Global.inventory,
		pet_dict,
		bestiary_dict,
		Global.equipped_items
	])
	
	file.close()
	print("Saved")
