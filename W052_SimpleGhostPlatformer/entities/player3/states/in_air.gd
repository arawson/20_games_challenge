extends "motion.gd"

export(float) var fall_max_speed = 300.0

export(NodePath) var grounded_state
onready var grounded = get_node(grounded_state)

func initialize(velocity: Vector2):
	self.velocity.x = velocity.x

func enter():
	.enter()
	velocity.y = 0

	
func handle_input(event):
	return .handle_input(event)
	
func update(delta):
	
	velocity.y += gravity_base
	
	owner.move_and_slide(velocity, Vector2.UP)
	
	if owner.is_on_floor():
		_signal_next_state(grounded)

