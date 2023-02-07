extends Camera2D

# how do you use the OverheadCamera?
# 1. Send commands to the camera all the time
# 2. Have a level-controller which _exclusively_ updates the current_owner field

# TODO There's another enum I have which could use this "x in [enum.values()]"

enum MOVE_TYPE { INSTANT, LINEAR, TIMED_SLERP }

signal camera_reached_target(target)

export(float) var default_target_follow_speed = 4.0
export(NodePath) var initial_target_path
onready var target: Node2D = get_node(initial_target_path)

var timed_start_pos: Vector2 = Vector2()
var move_type: int = MOVE_TYPE.INSTANT
var target_arrival_time: float = -1.0
var target_track_time: float = 0
var target_follow_speed_max: float = default_target_follow_speed

func set_follow_instant(node: Node2D):
	target = node
	move_type = MOVE_TYPE.INSTANT

func set_follow_linear(node: Node2D, follow_speed: float = -1):
	target = node
	move_type = MOVE_TYPE.LINEAR
	set_target_follow_speed(follow_speed)

func set_follow_arrive_at_then_instant(node: Node2D, start_pos: Vector2, arrival_time: float):
	target = node
	move_type = MOVE_TYPE.TIMED_SLERP
	target_track_time = 0.0
	target_arrival_time = arrival_time
	timed_start_pos = start_pos if start_pos != null else global_position

func set_target_follow_speed(follow_speed: float = -1):
	target_follow_speed_max = follow_speed if follow_speed > 0 else default_target_follow_speed

func _physics_process(delta):
	if target == null:
		return
	# essentially a tiny state machine
	if move_type == MOVE_TYPE.INSTANT:
		global_position = target.global_position
	elif move_type == MOVE_TYPE.LINEAR:
		global_position = global_position.linear_interpolate(target.global_position, delta * target_follow_speed_max)
	else:
		# is clamp really more clear than min here?
		target_track_time = clamp(target_track_time + delta, 0.0, target_arrival_time)
		var weight = target_track_time / target_arrival_time
		var slerpy = lerp(timed_start_pos, target.global_position, weight)
		global_position = slerpy
		print(slerpy)

		if target_track_time >= target_arrival_time:
			emit_signal("camera_reached_target", target)
			move_type = MOVE_TYPE.INSTANT
