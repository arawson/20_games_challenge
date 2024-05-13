extends Node2D


@onready var arrow_group: Node2D = %ArrowGroup


# Design Problem as of 2024-05-12: Shouldn't the map cursor have all of its
# motion code in here? I went looking for it and couldn't figure out how the
# heck the cursor moved around. Turns out it's in the UI controller. How are the
# arrow keys handled? By injecting a bus signal input_inject_selection which
# tells the map how to re-adjust the selection cursor. Isn't that a bit silly?


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainBus.input_unit_selected.connect(_on_input_unit_selected)
	MainBus.input_nothing_selected.connect(_on_input_nothing_selected)
	MainBus.unit_moved.connect(_on_unit_moved)


func _on_input_unit_selected(_unit: Unit, unit_block: UnitBlock):
	if unit_block.is_head:
		arrow_group.visible = true
	else:
		arrow_group.visible = false


func _on_input_nothing_selected(_coords: Vector2i, _global_pos: Vector2):
	arrow_group.visible = false


func _on_move_arrow_clicked(event: InputEvent, dir: Util.Direction):
	if (event is InputEventMouseButton
	and Input.is_action_just_pressed("pointer_action")):
		LogDuck.d("_on_move_arrow_clicked")
		MainBus.input_action_move.emit(dir, global_position)


func _on_rect_n_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.NORTH)


func _on_rect_s_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.SOUTH)


func _on_rect_w_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.WEST)


func _on_rect_e_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.EAST)


func _on_unit_moved(unit: Unit, _dir: Util.Direction, old_head_pos: Vector2):
	if global_position.distance_squared_to(old_head_pos) >= 25:
		return
	
	MainBus.input_inject_selection.emit(unit.get_head().global_position)
