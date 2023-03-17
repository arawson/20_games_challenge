extends BaseController

var target: FactionMember = null

onready var state_machine = $LobberStateMachine
onready var searching = $LobberStateMachine/Searching

func _on_LobberStateMachine_state_changed(current_state):
	pass


func _on_tree_exited_target(former_target):
	if not is_inside_tree():
		return
	if former_target != target:
		return

	target = null
	state_machine.change_state(searching)

