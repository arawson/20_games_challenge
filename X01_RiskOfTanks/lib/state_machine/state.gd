# Original Code: https://godotengine.org/asset-library/asset/516
# Licensed MIT as of 2023-01-11

class_name State
extends Node
# Base interface for all states: it doesn't do anything by itself,
# but forces us to pass the right arguments to the methods below
# and makes sure every State object had all of these methods.

# warning-ignore:unused_signal
signal finished(next_state)


# Initialize the state. E.g. change the animation.
func enter():
	pass

# Clean up the state. Reinitialize values like a timer.
func exit():
	pass


func handle_input(_event):
	pass


func update(_delta):
	pass

func _on_animation_finished(_anim_name):
	pass

func _signal_next_state(next: State, pop: bool = false) -> void:
	if (next == null):
		printerr("State Error: next state was null");
		return
	emit_signal("finished", next, pop)
