class_name FactionMember
extends KinematicBody2D

export(int) var faction_id = 0
export(float) var max_health = 100.0

var health: float = max_health

export(NodePath) var proc_pool_path
onready var proc_pool = get_node(proc_pool_path)

func _setup_projectile(proj):
	# step 1, copy our proc pool
	var new_proc_pool = proc_pool.duplicate(DUPLICATE_SCRIPTS)
	proj.proc_pool = new_proc_pool
	# print(proc_pool.get_instance_id())
	# print(new_proc_pool.get_instance_id())
	# For some reason, proc_pool and new_proc_pool share the same path but
	# will have different IDs. Very strange.

	proj.faction_id = faction_id
	pass

# Returns if the damage would kill the unit
func do_damage(damage: float) -> bool:
	health -= damage
	if health < 0:
		health = 0
		print("%s died" % self)
		return true
	return false
