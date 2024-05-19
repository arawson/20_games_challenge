class_name TacticsMapLayer
extends TileMapLayer


func align_node(n: Node2D) -> Vector2i:
	var coords = local_to_map(to_local(n.global_position))
	n.global_position = to_global(map_to_local(coords))
	return coords
