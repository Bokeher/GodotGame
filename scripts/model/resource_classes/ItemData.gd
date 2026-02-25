extends Resource
class_name ItemData

enum ItemType { NONE, RING, CHEST }

@export var id: int
@export var name: String
@export var type: ItemType
@export var description: String
@export var texture: Texture2D
