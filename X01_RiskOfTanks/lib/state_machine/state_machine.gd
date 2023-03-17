# Original Code: https://godotengine.org/asset-library/asset/516
# Licensed MIT as of 2023-01-11

class_name StateMachine
extends Node
# Base interface for a generic state machine.
# It handles initializing, setting the machine active or not
# delegating _physics_process, _input calls to the State nodes,
# and changing the current/active state.
# See the PlayerV2 scene for an example on how to use it.

signal state_changed(current_state)

# You should set a starting node from the inspector or on the node that inherits
# from this state machine interface. If you don't, the game will default to
# the first state in the state machine's children.
export(NodePath) var start_state
var states_map : Dictionary = {}

var states_stack = []
var current_state : State = null
var _active : bool = false setget set_active

func _ready():
	if not start_state:
		start_state = get_child(0).get_path()
	for child in get_children():
		# Only want to deal with valid states
		if child is State:
			var obj = {}
			obj.name = child
			obj.path = self.get_path_to(child)
			var err = child.connect("finished", self, "_change_state")
			child.set_physics_process(false)
			child.set_process_input(false)
			if err:
				printerr(err)

	set_active(false)
	call_deferred("initialize", get_node(start_state))

# Handle custom state-transition logic here.
# warning_ignore(unused_argument)
func _prepare_change_state(from: State, to: State) -> void:
	# TODO is there any sensible universal logic here?
	pass

func initialize(initial_state: State):
	set_active(true)
	states_stack.push_front(initial_state)
	current_state = states_stack[0]
	current_state.enter()

func set_active(value: bool):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null


func _unhandled_input(event):
	current_state.handle_input(event)


func _physics_process(delta: float):
	current_state.update(delta)


func _on_animation_finished(anim_name: String):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(new_state: State, pop : bool = false) -> void:
	if not _active:
		return

	# This is the hook to allow the derived machines to handle custom logic
	# on state transition.
	_prepare_change_state(current_state, new_state)

	current_state.exit()

	current_state.set_physics_process(false)
	current_state.set_process_input(false)

	if pop:
		states_stack.pop_front()
	else:
		states_stack[0] = new_state

	current_state = states_stack[0]

	current_state.set_physics_process(true)
	current_state.set_process_input(true)

	emit_signal("state_changed", current_state)

	if !pop:
		current_state.enter()
