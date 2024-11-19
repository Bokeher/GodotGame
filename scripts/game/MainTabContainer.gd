extends TabContainer

const TAB_NAMES = ["Upgrades", "Stats"];

func _ready():
	# Set custom tab names
	for i in range(min($".".get_tab_count(), TAB_NAMES.size())):
		$".".set_tab_title(i, TAB_NAMES[i])

