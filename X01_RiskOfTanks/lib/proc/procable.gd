class_name Procable
extends Node2D

var item: ProcItem
var is_consumed: bool = false
var quantity: int = 1

func _ready():
	assert(item != null)

func is_on_hit() -> bool:
	return item.on_hit

func is_on_kill() -> bool:
	return item.on_kill

# func clone() -> Node:
# 	return self.duplicate(DUPLICATE_SCRIPTS)

func roll_on_hit(_faction_projectile, _faction_member, _proc_pool) -> bool:
	return false

func do_on_hit(_faction_projectile, _faction_member, _updated_proc_pool) -> void:
	pass
	
func roll_on_kill(_faction_projectile, _faction_member, _proc_pool) -> bool:
	return false

func do_on_kill(_faction_projectile, _faction_member, _updated_proc_pool) -> void:
	pass
