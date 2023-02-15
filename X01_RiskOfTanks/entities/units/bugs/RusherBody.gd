extends BaseUnit

signal path_changed(path)

export(float) var MAX_SPEED = 200.0


onready var nav_agent = $NavAgent as NavigationAgent2D

var velocity = Vector2.ZERO
var did_arrive = false
var target_vector: Vector2 setget _set_target_vector, _get_target_vector

func _physics_process(_delta):
	if not target_vector:
		return
	
	var move_direction = global_position.direction_to(nav_agent.get_next_location())
	velocity = move_direction * MAX_SPEED
	nav_agent.set_velocity(velocity)

func _arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()

func _set_target_vector(value: Vector2):
	target_vector = value
	nav_agent.set_target_location(value)

func _get_target_vector():
	return target_vector

func _on_NavAgent_velocity_computed(safe_velocity):
	if not _arrived_at_location():
		velocity = move_and_slide(safe_velocity)
	elif not did_arrive:
		did_arrive = true
		# emit_signal("path_changed", [])
		# emit_signal("target_reached")


func _on_NavAgent_path_changed():
	emit_signal("path_changed", nav_agent.get_nav_path())
