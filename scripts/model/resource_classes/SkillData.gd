extends Resource
class_name SkillData

@export var id: int
@export var name: String
@export var description: String
@export var texture: Texture2D
@export var grid_position: Vector2i
@export var requirements: Array[SkillData]
@export var max_level: int
