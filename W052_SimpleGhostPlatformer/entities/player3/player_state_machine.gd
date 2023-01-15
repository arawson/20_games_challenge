extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var jump = $Jump
onready var die = $Die
onready var attack = $Attack
onready var ladder = $Ladder

func _ready():
	pass

func _prepare_change_state(from: State, to: State):
	# The base machine calls this so we can do some extra work before changing
	# states.
	if to in [jump, attack]:
		states_stack.push_front(current_state)

	if from == move and to == jump:
		jump.initialize(move.speed, move.velocity)
	
	

func _unhandled_input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
	if event.is_action_pressed("attack"):
		if current_state in [attack]:
			return
		_change_state(attack)
		return
	current_state.handle_input(event)
