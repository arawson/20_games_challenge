class_name TacticsMapLayer
extends TileMapLayer


# TODO promote this to live in the lib directory


func align_node(n: Node2D) -> Vector2i:
	var coords = local_to_map(to_local(n.global_position))
	n.global_position = to_global(map_to_local(coords))
	return coords


func global_to_map(pos: Vector2) -> Vector2i:
	return local_to_map(to_local(pos))


func map_to_global(coords: Vector2i) -> Vector2:
	return to_global(map_to_local(coords))
