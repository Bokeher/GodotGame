extends Control

@onready var item_id: int = $".".get_meta("item_id")
@onready var enemy_id: int = $".".get_meta("enemy_id")
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")
@onready var unknown: bool = $".".get_meta("unknown")

func _on_panel_mouse_entered() -> void:
	if(unknown): 
		var loot_table := Global.enemies[enemy_id - 1].loot_table
		
		for loot in loot_table:
			if item_id == loot["item_id"]:
				var drop_chance: float = loot["drop_chance"]
				var drop_chance_text := "Drop chance: %.2f%%" % (drop_chance*100)
				popup.popup("Unknown item", drop_chance_text)
		
		return
	
	var item := Global.items[item_id - 1]
	
	popup.popup(item.name, item.description)

func _on_panel_mouse_exited() -> void:
	popup.hide_()
