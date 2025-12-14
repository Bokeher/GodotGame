extends Resource
class_name LootEntry

@export var item: ItemData
@export_range(0.0, 1.0, 0.001) var drop_chance: float = 0.1
