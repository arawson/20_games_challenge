class_name FactionProjectile
extends Node

export(int) var faction_id = 0

var proc_pool setget set_proc_pool, get_proc_pool

func delete_self():
	if is_inside_tree():
		get_parent().remove_child(self)
	queue_free()

func set_proc_pool(p) -> void:
	if (proc_pool != null):
		self.remove_child(proc_pool)
		proc_pool.queue_free()
		proc_pool = null
	proc_pool = p
	self.add_child(p)
	pass

func get_proc_pool():
	return proc_pool
