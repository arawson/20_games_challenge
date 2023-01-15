extends "../motion.gd"

# warning-ignore-all:unused_class_variable
var speed = 0.0
var velocity = Vector2()

export(NodePath) var jump_path
onready var jump = get_node(jump_path)

func handle_input(event):
	if event.is_action_pressed("jump"):
		._signal_next_state(jump)
	return .handle_input(event)
