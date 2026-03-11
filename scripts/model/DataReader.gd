class_name DataReader

# File paths
const PATH_ENEMIES: String = "res://assets/jsons/enemies.json"
const PATH_STAGES: String = "res://assets/jsons/stages.json"
const PATH_UPGRADES: String = "res://assets/jsons/upgrades.json"
const PATH_SKILLS: String = "res://assets/jsons/skills.json"
const PATH_CLASSES_DIR: String = "res://assets/jsons/classes/"
const PATH_RESOURCES: String = "res://assets/resources/"
const PATH_RESOURCES_STATUSES: String = PATH_RESOURCES + "statuses/"

func read_enemies() -> void:
	if(!FileAccess.file_exists(PATH_ENEMIES)):
		push_error("Enemies file not found")
		return
	
	var file: FileAccess = FileAccess.open(PATH_ENEMIES, FileAccess.READ)
	var enemy_dicts: Array = JSON.parse_string(file.get_as_text()).enemies
	
	for enemy_dict: Dictionary in enemy_dicts:
		Global.enemies.append(Enemy.from_dict(enemy_dict))
	
	file.close()

func read_stages() -> void:
	if(!FileAccess.file_exists(PATH_STAGES)):
		push_error("Stages file not found")
		return
	
	var file: FileAccess = FileAccess.open(PATH_STAGES, FileAccess.READ)
	Global.stages = JSON.parse_string(file.get_as_text()).stages
	file.close()

func read_upgrades() -> void:
	if(!FileAccess.file_exists(PATH_UPGRADES)):
		push_error("Upgrades file not found")
		return
		
	var file: FileAccess = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	var upgrade_dicts: Array = JSON.parse_string(file.get_as_text()).upgrades
	
	Global.upgrades = []
	for upgrade_dict: Dictionary in upgrade_dicts:
		Global.upgrades.append(Upgrade.from_dict(upgrade_dict))
	
	file.close()
	
func read_skills() -> void:
	var PATH: String = Enums.get_class_json_path(Global.selected_class_id)
	
	if(!FileAccess.file_exists(PATH)):
		push_error("Skills file not found")
		return
		
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	var skill_dicts: Array = JSON.parse_string(file.get_as_text()).skills
	
	Global.skills = []
	for skill_dict: Dictionary in skill_dicts:
		Global.skills.append(Skill.from_dict(skill_dict))
	
	file.close()

func read_statuses() -> void:
	Global.statuses.clear()
	for res: Resource in load_resources_from_folder(PATH_RESOURCES_STATUSES):
		if res is StatusEffect:
			Global.statuses[res.id] = res

func load_resources_from_folder(path: String) -> Array:
	var resources: Array = []
	var dir := DirAccess.open(path)
	
	if dir == null:
		push_error("Cant open dir: %s" % path)
		return resources
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var res_path: String = path.path_join(file_name)
				var res: Resource = load(res_path)
				if res:
					resources.append(res)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return resources
