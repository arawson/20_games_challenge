extends UnitState

onready var wandering: UnitState = $"../Wandering"
onready var travelling: UnitState = $"../Travelling"


func enter():
	# entering searching is the same as the rusher's retarget
	var old_target = controller.target
	controller.target = controller.get_nearest_hostile()

	if controller.target != old_target:
		NodeUtil.disconnect_incoming_connections_from(controller, old_target)

	if controller.target == null:
		_signal_next_state(wandering)
	else:
		_signal_next_state(travelling)
		var _e = controller.target.connect("tree_exited", controller, "_on_tree_exited_target", [controller.target])
