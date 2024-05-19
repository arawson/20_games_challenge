extends Faction


@export var ui: UI


var selected: Unit = null


func _ready():
	super()
	assert(ui != null)
	ui.turn_completed.connect(_on_ui_turn_completed)
	MainBus.input_unit_selected.connect(_on_input_unit_selected)
	MainBus.input_nothing_selected.connect(_on_input_nothing_selected)
	MainBus.input_action_move.connect(_on_input_action_move)


func _turn_ready():
	LogDuck.d("player turn start")

	for c in unit_container.get_children():
		var u = c as Unit
		u.turn_ready()
	
	# UI goes last so it can update all its visuals
	ui.turn_ready()


func _on_ui_turn_completed():
	LogDuck.d("Player turn end")
	if _my_turn:
		_turn_end()


func turn_top(the_turn_number: int):
	ui.turn_number = the_turn_number


func _on_input_unit_selected(unit: Unit, _unit_block: UnitBlock):
	if unit.faction == self:
		selected = unit
	else:
		selected = null


func _on_input_nothing_selected(_coords: Vector2i, _global_pos: Vector2):
	selected = null


func _on_input_action_move(direction: Util.Direction, cursor_pos: Vector2):
	# TODO is this a good place to put the query to the map?
	LogDuck.d("_on_input_action_move", direction, cursor_pos)
	if selected == null:
		ui.unit_not_movable()
		return

	if selected.movement_left <= 0:
		# TODO go ding
		ui.unit_no_moves(selected)
		return
	
	if navigation_service.can_move_unit(selected, direction, cursor_pos):
		selected.move_head(direction)
	else:
		ui.unit_blocked(selected)
	