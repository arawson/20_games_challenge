extends State
# Collection of important methods to handle direction and animation.

export(float) var gravity_base = 25.0

var speed : float = 0.0
var velocity : Vector2 = Vector2()

func get_input_direction():
	var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0 # Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return input_direction # Vector2(1, 0)
