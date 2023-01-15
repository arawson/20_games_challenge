extends "motion.gd"

export(float) var jump_initial_impulse = -300.0
export(float) var jump_impulse_decay = 0.3
export(float) var jump_impulse_float_minimum = 10.0
#export(float) var air_acceleration = 30.0

export(NodePath) var in_air_state
onready var in_air = get_node(in_air_state)

export(NodePath) var grounded_state
onready var grounded = get_node(grounded_state)

var jump_impulse_current : float = 0.0

func initialize(velocity: Vector2):
	self.velocity.x = velocity.x


func enter():
	.enter()
	velocity.y = jump_initial_impulse
	jump_impulse_current = -jump_initial_impulse * jump_impulse_decay


func handle_input(event):
	pass

func update(delta):
	
	velocity.y += gravity_base
	
	if Input.is_action_pressed("jump") \
	&& jump_impulse_current >= jump_impulse_float_minimum:
		# gettin floaty
		velocity.y -= jump_impulse_current
		jump_impulse_current *= jump_impulse_decay
	
	owner.move_and_slide(velocity, Vector2.UP)
	
	if owner.is_on_floor():
		_signal_next_state(grounded)
		
	if velocity.y >= 0:
		_signal_next_state(in_air)
		pass
	
	pass
