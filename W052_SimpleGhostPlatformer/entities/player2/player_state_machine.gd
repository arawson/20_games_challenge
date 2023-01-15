extends StateMachine

onready var debug_state = get_node("../Character0006/StateNameDisplayer")

onready var in_air = $InAir
onready var rising_jump = $RisingJump
onready var grounded = $Grounded

func _ready():
	pass

func _prepare_change_state(from: State, to: State):
	# The base machine calls this so we can do some extra work before changing
	# states.
	debug_state.text = "%s" % to.name
#	if to in [jump, attack]:
#		states_stack.push_front(current_state)
#
	if to in [in_air, rising_jump, grounded] :
		to.initialize(from.velocity)

#	if from == move and to == jump:
#		jump.initialize(move.speed, move.velocity)
	
	

func _unhandled_input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
#	if event.is_action_pressed("attack"):
#		if current_state in [attack]:
#			return
#		_change_state(attack)
#		return
	current_state.handle_input(event)
