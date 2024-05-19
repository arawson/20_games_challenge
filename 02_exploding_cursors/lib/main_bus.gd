extends Node


signal input_inject_selection(global_pos: Vector2)
signal input_unit_selected(unit: Unit, unit_block: UnitBlock)
signal input_nothing_selected(coords: Vector2i, global_pos: Vector2)

signal input_action_move(direction: Util.Direction, cursor_pos: Vector2)
signal input_action_selected(unit: Unit, action: Action)
signal input_action_confirmed(unit: Unit, action: Action, coords: Vector2i, block: UnitBlock)

signal unit_moved(unit: Unit, dir: Util.Direction, old_head_pos: Vector2)
