extends "../in_air.gd"

export(float) var initial_vertical_speed = 200.0

func initialize(speed, velocity):
	horizontal_speed = speed
	if speed > 0.0:
		max_horizontal_speed = speed
	else:
		max_horizontal_speed = base_max_horizontal_speed
	enter_velocity = velocity


func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)

	if input_direction:
		horizontal_velocity = enter_velocity
	else:
		horizontal_velocity = Vector2()
	vertical_speed = initial_vertical_speed


func update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)

	move_horizontally(delta, input_direction)
#	animate_jump_height(delta)
	if height <= 0.0:
		_signal_next_state(idle)


func move_horizontally(delta, direction):
	if direction:
		horizontal_speed += air_acceleration * delta
	else:
		horizontal_speed -= air_deceleration * delta
	horizontal_speed = clamp(horizontal_speed, 0, max_horizontal_speed)

	var target_velocity = horizontal_speed * direction.normalized()
	var steering_velocity = (target_velocity - horizontal_velocity).normalized() * air_steering_power
	horizontal_velocity += steering_velocity

	owner.move_and_slide(horizontal_velocity)


func animate_jump_height(delta):
	vertical_speed -= gravity * delta
	height += vertical_speed * delta
	height = max(0.0, height)

	# owner.get_node("BodyPivot").position.y = -height
	owner.position.y = -height
