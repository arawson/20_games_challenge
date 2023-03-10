extends KinematicBody2D
# The Player has a State Machine, but the 2 are distinct

signal direction_changed(new_direction)

onready var state_displayer = $Character0006/StateNameDisplayer

var look_direction = Vector2.RIGHT setget set_look_direction

func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", look_direction)


func _on_StateMachine_state_changed(current_state):
	state_displayer.text = current_state.name
	pass # Replace with function body.
