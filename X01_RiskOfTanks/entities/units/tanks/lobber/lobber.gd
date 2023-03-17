extends BaseUnit

onready var state_machine = $LobberController/LobberStateMachine
onready var travelling = $LobberController/LobberStateMachine/Travelling

func _ready():
	var logger = HyperLog.log(self)
	# Sometimes push_back in the log method doesn't actually add the container to the
	# list of nodes, which is a big weird
	# work around that by only using HyperLog.log(self) once and re-using the return value
	logger.offset(Vector2(20,20))
	logger.text("health:")
	logger.bar("health", 0, health_max)
	logger.text("global_position")
	logger.text("current_state:name", state_machine)
	logger.text("next_location", travelling)
	pass
