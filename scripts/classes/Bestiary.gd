class_name Bestiary

var enemyEntries: Dictionary = {} # <enemy_id, entry>

func _init(entries: Dictionary):
	enemyEntries = entries

func set_entry(enemy_id: int, entry: BestiaryEntry) -> void:
	enemyEntries[enemy_id] = entry

func get_entry(enemy_id: int) -> BestiaryEntry:
	return enemyEntries[enemy_id]

func to_dicts() -> Array[Dictionary]:
	var dicts: Array[Dictionary] = []
	
	for enemy_id in enemyEntries:
		dicts.append({
			"enemy_id": enemy_id,
			"entry": enemyEntries[enemy_id].to_dict()
		})
	
	return dicts

static func from_dict(dict: Dictionary) -> Bestiary:
	return Bestiary.new(dict)
