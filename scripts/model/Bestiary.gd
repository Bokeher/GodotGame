class_name Bestiary

var enemyEntries: Dictionary[int, BestiaryEntry] = {} # <enemy_id, entry>

func _init(entries: Dictionary[int, BestiaryEntry] = {}) -> void:
	enemyEntries = entries

func set_entry(enemy_id: int, entry: BestiaryEntry) -> BestiaryEntry:
	enemyEntries[enemy_id] = entry
	return entry

func get_entry(enemy_id: int) -> BestiaryEntry:
	if(!enemyEntries.has(enemy_id)): return null
	
	return enemyEntries[enemy_id]

func hasItemDroppedFromEnemy(item_id: int, enemy_id: int) -> bool:
	var bestiary_entry: BestiaryEntry = get_entry(enemy_id)
	if bestiary_entry == null:
		return false
	
	var drops: Dictionary[int, bool] = bestiary_entry.items_dropped
	
	return drops.has(item_id)

# Bestiary contains BestiaryEntry objects 
# so these objects have to be converted to dictionary (used in saving)
func to_dict() -> Dictionary:
	var dict: Dictionary = {}
	
	for enemy_id in enemyEntries:
		dict[enemy_id] = enemyEntries[enemy_id].to_dict()
	
	return dict

# Undo the conversion from 'to_dict()' method (used in saving)
static func from_dict(dict: Dictionary) -> Bestiary:
	var entries: Dictionary = {}
	
	for enemy_id: int in dict:
		var entry: Dictionary = dict[enemy_id]
		entries[enemy_id] = BestiaryEntry.new(
			entry["times_slayed"], 
			entry["items_dropped"]
		)
	
	return Bestiary.new(entries)
