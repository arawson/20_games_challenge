class_name UI
extends Control


signal turn_completed()


@onready var map_cursor: Node2D = $MapCursor
@onready var unit_label: Label = $Bottom/UnitLabel


@export var turn_number: int:
	get:
		return turn_number
	set(value):
		turn_number = value
		turn_counter.text = "Turn #%d" % value

@onready var turn_counter = %TurnCounter


func _ready() -> void:
	assert(map_cursor != null)
	MainBus.input_unit_selected.connect(_on_input_unit_selected)
	MainBus.input_nothing_selected.connect(_on_input_nothing_selected)


func _on_end_turn_pressed() -> void:
	print("ui turn end")
	turn_completed.emit()


func _on_input_unit_selected(unit: Unit, block: UnitBlock):
	LogDuck.d("unit selected")
	map_cursor.global_position = block.global_position
	unit_label.text = "%s - Moves Left: %d" % [unit.base.name, unit.movement_left]


func _on_input_nothing_selected(coords: Vector2i, global_pos: Vector2):
	LogDuck.d("nothing selected")
	map_cursor.global_position = global_pos
	unit_label.text = "Nothing"


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_up"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(0, -30))
	elif Input.is_action_just_pressed("move_down"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(0, 30))
	elif Input.is_action_just_pressed("move_right"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(30, 0))
	elif Input.is_action_just_pressed("move_left"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(-30, 0))
