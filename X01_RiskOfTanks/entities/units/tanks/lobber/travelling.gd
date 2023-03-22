extends UnitState

export(NodePath) var nav_agent_path
onready var nav_agent: NavigationAgent2D = get_node(nav_agent_path)

onready var searching = $"../Searching"
onready var lobbing = $"../Lobbing"

var target_vector: Vector2 setget _set_target_vector, _get_target_vector
var next_location: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
# TODO figure out why did_arrive existed in the sample code
var did_arrive: bool


func enter():
	velocity = Vector2.ZERO
	did_arrive = false

	# queue up the search re-eval
	get_tree()\
		.create_timer(unit.unit_stats.chase_re_eval_time)\
		.connect("timeout", self, "re_evaluate_chase")

	# figure out a position that isn't just the target
	var targ = controller.target.global_position
	_set_target_vector(targ)

func _physics_process(delta: float):
	target_vector = controller.target.global_position
	next_location = nav_agent.get_next_location()
	var move_direction = unit.global_position.direction_to(next_location)
	velocity = move_direction * unit.unit_stats.speed_max
	nav_agent.set_velocity(velocity)

	var safe_velocity = yield(nav_agent, "velocity_computed")

	if not _arrived_at_location():
		velocity = unit.move_and_slide(safe_velocity)
	elif not did_arrive:
		did_arrive = true


func re_evaluate_chase():
	if not is_physics_processing(): # already switched away
		return

	var target_distance = controller.target.global_position.distance_to(unit.global_position)
	if target_distance > unit.unit_stats.chase_initiation_range:
		_signal_next_state(searching)
		return

	if target_distance > unit.unit_stats.attack_initiation_range:
		# try to get close enough again
		_signal_next_state(self)
		return

	_signal_next_state(lobbing)



func _arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()


func _set_target_vector(value: Vector2):
	target_vector = value
	nav_agent.set_target_location(value)


func _get_target_vector():
	return target_vector
