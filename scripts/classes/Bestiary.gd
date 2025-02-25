class_name Bestiary

var enemyEntries: Dictionary = {} # <enemy_id, entry>

func _init(entries: Dictionary):
	enemyEntries = entries

func set_entry(enemy_id: int, entry: BestiaryEntry) -> BestiaryEntry:
	enemyEntries[enemy_id] = entry
	return entry

func get_entry(enemy_id: int) -> BestiaryEntry:
	if(!enemyEntries.has(enemy_id)): return null
	
	return enemyEntries[enemy_id]

func to_dicts() -> Array[Dictionary]:
	var dicts: Array[Dictionary] = []
	
	for enemy_id in enemyEntries:
		dicts.append({
			"enemy_id": enemy_id,
			"entry": enemyEntries[enemy_id].to_dict()
		})
	
	return dicts

static func from_dicts(dicts: Dictionary) -> Bestiary:
	# TODO: fix this
	return Bestiary.new(dicts)
