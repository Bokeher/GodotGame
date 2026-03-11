class_name BestiaryEntry

var times_slayed: int
var items_dropped: Dictionary[int, bool] # <id, has_dropped>

func _init(_times_slayed: int, _items_dropped: Dictionary) -> void:
	times_slayed = _times_slayed
	items_dropped = _items_dropped

func add_slay() -> void:
	times_slayed += 1

func add_item_dropped(item_id: int) -> void:
	if(has_dropped_item(item_id)): return
	
	items_dropped[item_id] = true

func has_dropped_item(item_id: int) -> bool:
	return items_dropped.has(item_id) && items_dropped[item_id]

func to_dict() -> Dictionary:
	return {
		"times_slayed": times_slayed,
		"items_dropped": items_dropped,
	}

static func from_dict(data: Dictionary) -> BestiaryEntry:
	return BestiaryEntry.new(
		data.get("times_slayed", 0),
		data.get("items_dropped", null),
	)
