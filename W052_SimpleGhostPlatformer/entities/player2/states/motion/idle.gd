extends "on_ground.gd"

export(NodePath) var move_path
onready var move = get_node(move_path)

func enter():
	# owner.get_node("AnimationPlayer").play("idle")
	pass


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", move)
