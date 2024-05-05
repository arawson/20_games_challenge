extends Node


enum Direction { NORTH, EAST, WEST, SOUTH}


func delete_all_children(node: Node):
	for child in node.get_children():
		child.queue_free()
