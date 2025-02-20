class_name BestiaryEntry

var enemy_id: int
var times_slayed: int
var items_dropped: Dictionary # <id, has_dropped: bool>

func _init(_enemy_id: int, _times_slayed: int, _items_dropped: Dictionary):
	enemy_id = _enemy_id
	times_slayed = _times_slayed
	items_dropped = _items_dropped

func to_dict() -> Dictionary:
	return {
		"enemy_id": enemy_id,
		"times_slayed": times_slayed,
		"items_dropped": items_dropped,
	}

static func from_dict(data: Dictionary) -> BestiaryEntry:
	return BestiaryEntry.new(
		data.get("enemy_id", -1),
		data.get("times_slayed", 0),
		data.get("items_dropped", null),
	)
