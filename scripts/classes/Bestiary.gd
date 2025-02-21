class_name Bestiary

var BESTIARY_PATH

var enemyEntries: Dictionary = {} # <enemy_id, entry>

func _init(entries: Dictionary):
	enemyEntries = entries

func set_entry(enemy_id: int, entry: BestiaryEntry) -> void:
	enemyEntries[enemy_id] = entry

func get_entry(enemy_id: int) -> BestiaryEntry:
	return enemyEntries[enemy_id]

func to_dict() -> Dictionary:
	return enemyEntries

static func from_dict(dict: Dictionary) -> Bestiary:
	return Bestiary.new(dict)
