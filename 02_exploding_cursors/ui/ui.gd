class_name UI
extends Control


signal turn_completed()


@onready var map_cursor: Node2D = $MapCursor
@onready var unit_label: Label = $Bottom/UnitLabel
@onready var action_cards: Container = %ActionCards
@onready var sound_blocked = $Audio/Blocked
@onready var sound_no_moves = $Audio/NoMoves


@export var selected: UnitBlock:
	get:
		return selected
	set(value):
		selected = value

		if is_inside_tree():
			Util.delete_all_children(action_cards)

			if selected == null:
				unit_label.text = "Nothing Selected"

			else:
				var unit = selected.unit
				map_cursor.global_position = selected.global_position
				unit_label.text = "%s - Moves Left: %d" % [unit.base.name, unit.movement_left]

				for a in unit.base.actions:
					LogDuck.d("add unit action %s" % a.name)
					var button = Button.new()
					button.text = a.name
					button.icon = a.icon
					action_cards.add_child(button)
					button.pressed.connect(_on_action_button_pressed.bind(unit, a))


@export var turn_number: int:
	get:
		return turn_number
	set(value):
		turn_number = value
		if is_inside_tree():
			turn_counter.text = "Turn #%d" % value

@onready var turn_counter = %TurnCounter


func _ready() -> void:
	assert(map_cursor != null)
	MainBus.input_unit_selected.connect(_on_input_unit_selected)
	MainBus.input_nothing_selected.connect(_on_input_nothing_selected)
	MainBus.unit_moved.connect(_on_unit_moved)


func _on_end_turn_pressed() -> void:
	print("ui turn end")
	turn_completed.emit()


func _on_input_unit_selected(_unit: Unit, block: UnitBlock):
	LogDuck.d("unit selected")
	selected = block


func _on_action_button_pressed(unit: Unit, action: Action):
	LogDuck.d("action button pressed", unit.name, action.name)


func _on_input_nothing_selected(_coords: Vector2i, global_pos: Vector2):
	LogDuck.d("nothing selected")
	selected = null
	map_cursor.global_position = global_pos


func _input(_event: InputEvent) -> void:
	# TODO replace with Util.displacement
	if Input.is_action_just_pressed("move_up"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(0, -30))
	elif Input.is_action_just_pressed("move_down"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(0, 30))
	elif Input.is_action_just_pressed("move_right"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(30, 0))
	elif Input.is_action_just_pressed("move_left"):
		MainBus.input_inject_selection.emit(map_cursor.global_position + Vector2(-30, 0))


func _on_unit_moved(unit: Unit, _direction: Util.Direction, _old_head_pos: Vector2):
	if unit == selected.unit:
		selected = unit.get_head()


func turn_ready():
	selected = selected # seems silly, but our setter makes this work


func unit_no_moves(unit: Unit):
	if selected and selected.unit == unit:
		sound_no_moves.playing = true


func unit_blocked(unit: Unit):
	if selected and selected.unit == unit:
		sound_blocked.playing = true
