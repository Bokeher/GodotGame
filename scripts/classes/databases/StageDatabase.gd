extends GenericDatabase
#class_name StageDatabase 
# THIS IS AUTOLOAD

func _init() -> void:
	_dir_path = "res://assets/resources/stages/"
	_data_type = "Stage"

func _ready() -> void:
	super._ready()
	is_data_valid()

func get_by_id(id: int) -> StageData:
	return super.get_by_id(id)

func is_data_valid() -> void:
	for stage_id: int in _data:
		var stage: StageData = _data[stage_id]
		if not stage.are_spawn_entries_valid():
			print("Stage '%s' has invalid data" % stage.name)
	
