extends Node


enum Direction { NORTH, EAST, WEST, SOUTH}


func delete_all_children(node: Node):
	for child in node.get_children():
		child.queue_free()


func displacement(dir: Direction) -> Vector2:
	match dir:
		Direction.NORTH:
			return Vector2(0, 48)
		Direction.EAST:
			return Vector2(48, 0)
		Direction.SOUTH:
			return Vector2(0, -48)
		Direction.WEST:
			return Vector2(-48, 0)

	return Vector2.ZERO
