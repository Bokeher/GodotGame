extends Control

@onready var item_id: int = $".".get_meta("item_id")
@onready var enemy_id: int = $".".get_meta("enemy_id")
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")
@onready var unknown: bool = $".".get_meta("unknown")
@onready var drop_chance: float = get_drop_chance()
@onready var drop_chance_text: String = get_drop_chance_text()

@onready var item: ItemData = ItemDatabase.get_by_id(item_id)

func _ready() -> void:
	$DropChance.text = drop_chance_text
	
	var texture: Texture2D = item.texture
	
	if(!Global.bestiary.hasItemDroppedFromEnemy(item_id, enemy_id)):
		$".".set_meta("unknown", true)
		texture = load("res://assets/sprites/unknown.png")
	
	$LootImage.texture = texture

func _on_loot_image_mouse_entered() -> void:
	$Background.color = Enums.get_background_color(true)
	
	if(unknown):
		popup.popup("Unknown item", "Drop chance: " + drop_chance_text)
		return
	
	popup.popup(item.name, item.description)

func get_drop_chance() -> float:
	var loot_table := Global.enemies[enemy_id - 1].loot_table
	
	for loot in loot_table:
		if item_id == loot["item_id"]:
			return loot["drop_chance"]
	
	return -1

func get_drop_chance_text() -> String:
	var drop_percent: float = drop_chance * 100
	
	var drop_percent_str: String = "%.2f" % drop_percent
	drop_percent_str = drop_percent_str.rstrip("0")
	drop_percent_str = drop_percent_str.rstrip(".")
	
	return drop_percent_str + "%"

func _on_loot_image_mouse_exited() -> void:
	$Background.color = Enums.get_background_color(false)
	
	popup.hide_()
