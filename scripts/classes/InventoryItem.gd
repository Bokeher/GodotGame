class_name InventoryItem

var id: int
var amount: int

func _init(_id: int, _amount: int):
	id = _id
	amount = _amount

# Used in saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"amount": amount
	}

# Used in reading from savefile
static func from_dict(data: Dictionary) -> InventoryItem:
	var instance = InventoryItem.new(
		data.get("id", -1),
		data.get("amount", 0),
	)
	
	return instance
