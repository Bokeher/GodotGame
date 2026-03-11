extends TabContainer

const TAB_NAMES = ["Upgrades", "Stats", "Skills", "Inventory", "Pets", "Bestiary", "Achievements"]

func _ready() -> void:
	# Set position like this to easily access it in other scenes
	$".".position = Global.MAIN_TAB_CONTAINER_POSITION
	
	# Set custom tab names
	for i in range(min($".".get_tab_count(), TAB_NAMES.size())):
		$".".set_tab_title(i, TAB_NAMES[i])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("JumpUpgrades"):
		$".".current_tab = 0
	elif Input.is_action_just_pressed("JumpStats"):
		$".".current_tab = 1
	elif Input.is_action_just_pressed("JumpSkills"):
		$".".current_tab = 2
	elif Input.is_action_just_pressed("JumpInventory"):
		$".".current_tab = 3
	elif Input.is_action_just_pressed("JumpPets"):
		$".".current_tab = 4
	elif Input.is_action_just_pressed("JumpBestiary"):
		$".".current_tab = 5

func _on_tab_changed(tab: int) -> void:
	# TODO: add here all focus grabers
	if(tab == 5): # 5 == BestiaryTab
		$BestiaryPanel/Bestiary.update_bestiary()
	
