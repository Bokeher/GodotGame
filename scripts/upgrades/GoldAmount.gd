extends Label

func _ready() -> void:
	update_gold()

func update_gold() -> void:
	$".".text = str(Global.player.gold) + " Gold"
