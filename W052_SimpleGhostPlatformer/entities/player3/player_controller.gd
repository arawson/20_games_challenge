extends KinematicBody2D
# The Player has a State Machine, but the 2 are distinct

signal direction_changed(new_direction)

onready var state_displayer = $Character0006/StateNameDisplayer

# TODO learn what this syntax is
var look_direction = Vector2.RIGHT setget set_look_direction

# the sample had a take_damage and a set_dead, I don't need those just yet
# mine will be different anyway

func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", look_direction)


func _on_StateMachine_state_changed(current_state):
	state_displayer.text = current_state.name
	pass # Replace with function body.
