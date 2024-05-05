extends Node2D


@onready var arrow_group: Node2D = %ArrowGroup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainBus.input_unit_selected.connect(_on_input_unit_selected)
	MainBus.input_nothing_selected.connect(_on_input_nothing_selected)


func _on_input_unit_selected(_unit: Unit, unit_block: UnitBlock):
	if unit_block.is_head:
		arrow_group.visible = true
	else:
		arrow_group.visible = false


func _on_input_nothing_selected(_coords: Vector2i, _global_pos: Vector2):
	arrow_group.visible = false


func _on_move_arrow_clicked(event: InputEvent, dir: Util.Direction):
	if (event is InputEventMouseButton
	and Input.is_action_just_pressed("action")):
		MainBus.input_action_move.emit(dir, global_position)


func _on_rect_n_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.NORTH)


func _on_rect_s_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.SOUTH)


func _on_rect_w_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.WEST)


func _on_rect_e_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.EAST)
