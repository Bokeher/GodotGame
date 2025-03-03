extends Control

var bestiary = null
var entries = null

func _ready():
	entries = Global.bestiary.enemyEntries
	
	for enemy_id in entries:
		var label = Label.new()
		label.text = str(enemy_id)
		$ScrollContainer/BestiaryList.add_child(label)
		# TODO: display here all bestiary entries
