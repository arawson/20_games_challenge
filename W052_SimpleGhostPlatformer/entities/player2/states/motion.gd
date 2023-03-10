extends State
# Collection of important methods to handle direction and animation.

export(NodePath) var idle_path
onready var idle = get_node(idle_path)

func get_input_direction():
	var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0 # Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return input_direction


func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
