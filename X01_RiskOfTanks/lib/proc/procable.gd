class_name Procable
extends Node2D

export(bool) var is_consumed = false

func _ready():
	pass

func clone() -> Node:
	return self.duplicate(DUPLICATE_SCRIPTS)

# todo use a enum for proc triggers
func is_on_hit() -> bool:
	return false
	
func is_on_kill() -> bool:
	return false

func roll_on_hit(_faction_projectile, _faction_member, _proc_pool) -> bool:
	return false

func do_on_hit(_faction_projectile, _faction_member, _new_proc_pool) -> void:
	pass
	
func roll_on_kill(_faction_projectile, _faction_member, _proc_pool) -> bool:
	return false

func do_on_kill(_faction_projectile, _faction_member, _new_proc_pool) -> void:
	pass
