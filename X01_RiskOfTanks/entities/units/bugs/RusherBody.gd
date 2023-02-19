extends BaseUnit

signal path_changed(path)
signal collided_with_enemy(faction_member)
# future signals might be "in_range_of_enemy"(faction_member, ability)

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

	var safe_velocity = yield(nav_agent, "velocity_computed")
	
	if not _arrived_at_location():
		velocity = move_and_slide(safe_velocity)
	elif not did_arrive:
		did_arrive = true
		emit_signal("path_changed", [])

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var faction_member = collision.collider as FactionMember
		if faction_member == null or faction_member.faction_id == faction_id:
			continue
		
		# the controller has all the brains, so we send a signal out
		# even if it feels a little silly to do so
		emit_signal("collided_with_enemy", faction_member)

func _arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()

func _set_target_vector(value: Vector2):
	target_vector = value
	nav_agent.set_target_location(value)

func _get_target_vector():
	return target_vector


func _on_NavAgent_path_changed():
	emit_signal("path_changed", nav_agent.get_nav_path())
