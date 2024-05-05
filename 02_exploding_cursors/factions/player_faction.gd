extends Faction


@export var ui: UI


var _is_turn_active: bool = false


func _ready():
	super()
	assert(ui != null)
	ui.turn_completed.connect(_on_ui_turn_completed)


func turn_ready():
	LogDuck.d("player turn start")
	_is_turn_active = true
	for c in unit_container.get_children():
		var u = c as Unit
		u.turn_ready()


func _on_ui_turn_completed():
	print("player turn end")
	if _is_turn_active:
		turn_completed.emit(faction_base.name)
	_is_turn_active = false


func turn_top(turn_number: int):
	ui.turn_number = turn_number
