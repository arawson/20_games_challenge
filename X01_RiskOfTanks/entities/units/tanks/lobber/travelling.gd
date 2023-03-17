extends UnitState

export(NodePath) var nav_agent_path
onready var nav_agent: NavigationAgent2D = get_node(nav_agent_path)

var target_vector: Vector2 setget _set_target_vector, _get_target_vector
var next_location: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
# TODO figure out why did_arrive existed in the sample code
var did_arrive: bool


func enter():
	velocity = Vector2.ZERO
	did_arrive = false


func _physics_process(delta: float):
	target_vector = controller.target.global_position
	next_location = nav_agent.get_next_location()
	var move_direction = unit.global_position.direction_to(next_location)
	velocity = move_direction * unit.unit_stats.speed_max

	var safe_velocity = yield(nav_agent, "velocity_computed")

	if not _arrived_at_location():
		velocity = unit.move_and_slide(safe_velocity)
	elif not did_arrive:
		did_arrive = true
		# emit_signal("path_changed", [])

	HyperLog.sketch_line(controller.global_position, Vector2.ZERO)#next_location)


func _arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()


func _set_target_vector(value: Vector2):
	target_vector = value
	nav_agent.set_target_location(value)


func _get_target_vector():
	return target_vector
