extends Procable


var projectile_scene = preload("res://entities/bullets/Missile.tscn")


func roll_on_hit(_faction_projectile, _faction_member: FactionMember, _proc_pool) -> bool:
	# Normally, you would want a probability to roll here
	return true


func do_on_hit(projectile_source: FactionProjectile, member: FactionMember, updated_proc_pool) -> void:
	# launch a missile in a random direction
	var angle = RandomUtil.angle()

	var proc_pool = ProcPool.new()
	proc_pool.clone_from(updated_proc_pool)
	
	var projectile = projectile_scene.instance()
	projectile.initialize_projectile(
		projectile_source.projectile_root_path,
		projectile_source.faction_id,
		projectile_source.damage_base,
		proc_pool
	)

	projectile_source.projectile_root.get_parent().add_child(projectile)

	projectile.initialize(proc_pool.originator, angle)
