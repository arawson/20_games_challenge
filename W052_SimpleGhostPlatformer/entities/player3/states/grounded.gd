extends "motion.gd"

export(float) var run_max_speed = 150.0
export(float) var run_acceleration = 7.0
export(float) var run_friction = 30.0
export(float) var coyote_time = 0.05

export(NodePath) var in_air_state
onready var in_air = get_node(in_air_state)

export(NodePath) var rising_jump_state
onready var rising_jump = get_node(rising_jump_state)

var coyote_timer: float = 0.0

func initialize(velocity: Vector2):
	self.velocity.x = velocity.x

func enter():
	.enter()
	velocity.y = 0
	coyote_timer = coyote_time
	pass
	
func handle_input(event):
	return .handle_input(event)

func update(delta):
	# we don't need delta since move_and_slide already uses it
	
	var input_direction = get_input_direction()
	
	if input_direction.x == 0:
		if velocity.x > 0:
			velocity.x = clamp(velocity.x - run_friction, 0, +run_max_speed)
		else:
			velocity.x = clamp(velocity.x + run_friction, -run_max_speed, 0)
	else:
		velocity.x += input_direction.x * run_acceleration
	velocity.y += gravity_base
	
	velocity.x = clamp(velocity.x, -run_max_speed, +run_max_speed)
	
	var colliders = owner.move_and_slide(velocity, Vector2.UP)
	
	if not owner.is_on_floor():
		# experiment: using coyote time to delay the in_air state itself
		if coyote_timer >= 0:
			coyote_timer -= delta
			velocity.y = 0
		else:
			_signal_next_state(in_air)
			return
	else:
		velocity.y = 0.0
	
	if Input.is_action_just_pressed("jump") and coyote_timer >= 0:
		#TODO add jump input buffering
		_signal_next_state(rising_jump)
	
	# is owner here defaulting to the root of the scene when it gets
	# instantiated in the level?
	
	
	if owner.get_slide_count() == 0:
		return
	
	return owner.get_slide_collision(0)
