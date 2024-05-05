extends Faction

func _turn_ready():
	print("dummy faction starts and ends turn immediately")
	_turn_end()
