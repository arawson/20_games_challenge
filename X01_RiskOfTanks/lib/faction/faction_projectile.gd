class_name FactionProjectile
extends Node2D

export(int) var faction_id = 0
export(float) var damage_base = 10.0

var proc_pool: ProcPool setget set_proc_pool, get_proc_pool

# TODO: the projectile also acts as a builder of damage scaling

func delete_self():
	if is_inside_tree():
		get_parent().remove_child(self)
	queue_free()
	print("delete object %s" % self.get_instance_id())

func set_proc_pool(p: ProcPool) -> void:
	if (proc_pool != null):
		self.remove_child(proc_pool)
		proc_pool.queue_free()
		proc_pool = null
	proc_pool = p
	self.add_child(p)
	print("%s.proc_pool = %s" % [self.get_instance_id(), p])
	pass

func get_proc_pool():
	return proc_pool

# returns true if the target was valid to proc on
func do_proc_on(body) -> bool:
	var faction_member = body as FactionMember
	if faction_member != null:
		if faction_member.faction_id != faction_id:
			
			if faction_member.do_damage(damage_base):
				self.proc_pool.trigger_on_kill(self, faction_member)

			self.proc_pool.trigger_on_hit(self, faction_member)
		return true
	
	return false
