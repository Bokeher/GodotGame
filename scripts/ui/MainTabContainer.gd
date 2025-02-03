extends TabContainer

const TAB_NAMES = ["Upgrades", "Stats", "Skills", "Inventory"]

func _ready():
	# Set position like this to easily access it in other scenes
	$".".position = Global.MAIN_TAB_CONTAINER_POSITION
	
	# Set custom tab names
	for i in range(min($".".get_tab_count(), TAB_NAMES.size())):
		$".".set_tab_title(i, TAB_NAMES[i])

func _process(_delta):
	if Input.is_action_just_pressed("JumpUpgrades"):
		$".".current_tab = 0
	if Input.is_action_just_pressed("JumpStats"):
		$".".current_tab = 1
	if Input.is_action_just_pressed("JumpSkills"):
		$".".current_tab = 2
	if Input.is_action_just_pressed("JumpInventory"):
		$".".current_tab = 3
