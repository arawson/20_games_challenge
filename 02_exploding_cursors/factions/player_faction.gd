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
	MainBus.input_action_selected.connect(_on_input_action_selected)
	MainBus.input_action_confirmed.connect(_on_input_action_confirmed)


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


func _turn_top(the_turn_number: int):
	ui.turn_number = the_turn_number


func _on_input_unit_selected(unit: Unit, _unit_block: UnitBlock):
	if unit.faction == self:
		selected = unit
	else:
		selected = null


func _on_input_nothing_selected(_coords: Vector2i, _global_pos: Vector2):
	selected = null


func _on_input_action_move(direction: Util.Direction, cursor_pos: Vector2):
	if !_my_turn:
		return

	LogDuck.d("_on_input_action_move", direction, cursor_pos)
	if selected == null:
		ui.unit_not_movable()
		return

	if selected.movement_left <= 0:
		ui.unit_no_moves(selected)
		return
	
	if navigation_service.can_move_unit(selected, direction, cursor_pos):
		selected.move_head(direction)
	else:
		ui.unit_blocked(selected)
	

func _on_input_action_selected(unit: Unit, action: Action):
	assert(unit != null)
	assert(action != null)
	assert(unit.faction == self)
	assert(unit.base.actions.find(action) != -1)

	if !_my_turn:
		return

	if unit.actions_left <= 0:
		ui.unit_no_actions(unit)
		return

	ui.activate_action(unit, action)


func _on_input_action_confirmed(unit: Unit, action: Action,
coords: Vector2i, block: UnitBlock):
	assert(unit != null)
	assert(action != null)
	assert(not action.target_empties or not block)
	assert(not action.target_enemies or (block and block.faction != self))
	assert(not action.target_friendlies or (block and block.faction == self))
	
	if !_my_turn:
		return

	#TODO what should apply actions to units? probably a combat service
