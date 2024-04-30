extends Faction


var _is_turn_active: bool = false


func _ready():
	MainBus.ui_turn_completed.connect(_on_ui_turn_completed)


func turn_ready():
	print("player turn start")
	_is_turn_active = true


func _on_ui_turn_completed():
	print("player turn end")
	if _is_turn_active:
		turn_completed.emit()
	_is_turn_active = false

