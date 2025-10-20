extends Timer

func _ready() -> void:
	$".".wait_time = Global.warrior_class.BLOODRAGE_BUFF_DURATION_SECS

func start_timer() -> void:
	var bloodrage = Global.skills[Enums.WarriorSkillIds.BLOODRAGE - 1]
	
	if bloodrage.level == 0:
		return
	
	$".".start()
	Global.warrior_class.bloodrage_is_active = true

func _on_timeout() -> void:
	Global.warrior_class.bloodrage_is_active = false
