extends Node

const ABILITY_NOTHING = preload("res://entities/abilities/nothing.tres")



func get_faction_container(faction_id: int) -> FactionContainer:
	assert(faction_id != 0)

	var nodes = get_tree().get_nodes_in_group("faction_container")
	for node in nodes:
		if node is FactionContainer and node.faction_id == faction_id:
			return node as FactionContainer
	return null

func get_other_faction_containers(my_faction_id: int) -> Array: # of FactionContainer
	assert(my_faction_id != 0)

	var nodes = get_tree().get_nodes_in_group("faction_container")
	var rval = []
	for node in nodes:
		if node is FactionContainer and node.faction_id != my_faction_id:
			rval.append(node)
	return rval
