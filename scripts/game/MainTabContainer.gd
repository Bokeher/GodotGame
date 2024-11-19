extends TabContainer

const TAB_NAMES = ["Upgrades", "Stats"];

func _ready():
	# Set custom tab names
	for i in range($".".get_tab_count()):
		$".".set_tab_title(i, TAB_NAMES[i])

