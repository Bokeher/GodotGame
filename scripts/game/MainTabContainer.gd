extends TabContainer

const TAB_NAMES = ["Upgrades", "Stats", "Skills"]

func _ready():
	# Set position like this to easily access it in other scenes
	$".".position = Global.MAIN_TAB_CONTAINER_POSITION
	
	# Set custom tab names
	for i in range(min($".".get_tab_count(), TAB_NAMES.size())):
		$".".set_tab_title(i, TAB_NAMES[i])
