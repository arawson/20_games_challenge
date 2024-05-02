class_name UI
extends Control


signal turn_completed()


@onready var map_cursor: Node2D = $MapCursor


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
	pass


func _on_input_nothing_selected(coords: Vector2i, global_pos: Vector2):
	map_cursor.global_position = global_pos
	pass
