extends Node


enum Direction { NORTH, EAST, WEST, SOUTH}


const Godot = preload("res://icon.svg")
const HalfDisplacement = Vector2(24, 24)


func delete_all_children(node: Node):
	for child in node.get_children():
		child.queue_free()


func displacement(dir: Direction) -> Vector2:
	match dir:
		Direction.NORTH:
			return Vector2(0, -48)
		Direction.EAST:
			return Vector2(48, 0)
		Direction.SOUTH:
			return Vector2(0, 48)
		Direction.WEST:
			return Vector2(-48, 0)

	return Vector2.ZERO

func displacementi(dir: Direction) -> Vector2i:
	match dir:
		Direction.NORTH:
			return Vector2i(0, -1)
		Direction.EAST:
			return Vector2(1, 0)
		Direction.SOUTH:
			return Vector2(0, 1)
		Direction.WEST:
			return Vector2(-1, 0)

	return Vector2i.ZERO
