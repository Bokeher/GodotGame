extends TabContainer

const TAB_NAMES = ["Upgrades", "Stats", "Skills", "Inventory", "Pets", "Bestiary"]

func _ready() -> void:
	# Set position like this to easily access it in other scenes
	$".".position = Global.MAIN_TAB_CONTAINER_POSITION
	
	# Set custom tab names
	for i in range(min($".".get_tab_count(), TAB_NAMES.size())):
		$".".set_tab_title(i, TAB_NAMES[i])

func _process(_delta) -> void:
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

func _on_tab_changed(tab):
	# TODO: add here all focus grabers
	if(tab == 5): # 5 == BestiaryTab
		var childs = $BestiaryPanel/Bestiary/ScrollContainer/BestiaryList.get_children()
		if childs.is_empty():
			return
		
		var selected_child = childs[Global.curr_bestiary_enemy_id - 1]
		selected_child.focus()
		selected_child.get_node("ItemButton").grab_focus()
	
