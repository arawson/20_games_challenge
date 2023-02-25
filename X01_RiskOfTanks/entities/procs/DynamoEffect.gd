extends ProcableDamage

var projectile_scene = preload("res://entities/bullets/DynamoProjectile.tscn")

func _ready():
	pass

func roll_on_hit(_faction_projectile, _faction_member: FactionMember, _proc_pool) -> bool:
	# Normally, you would want a probability to roll here
	return true

func do_on_hit(projectile: FactionProjectile, member: FactionMember, updated_proc_pool) -> void:
	# reveal the dynamo's collision to start a new proc pool
	print("dynamo effect")
	$AreaOfEffect.monitoring = true

	var hittables = []

	for b in $AreaOfEffect.get_overlapping_bodies():
		var member2: FactionMember = b as FactionMember
		if member2 == null:
			continue
		if member2 == member:
			continue
		if member2.faction_id == projectile.faction_id:
			continue
		hittables.append(member2)
	
	# randomly select targets out of list
	var targets = RandomUtil.pick(2, hittables)

	for t in targets:
		print("hitting target: %s" % t)
		if !t.do_damage(damage_base):
			print("spawn dynamo projectile")
			# take this up into Procable as a helper function
			var proc_pool = ProcPool.new()
			proc_pool.clone_from(updated_proc_pool)

			var proj = projectile_scene.instance()
			proj.initialize_projectile(
				projectile.projectile_root_path,
				projectile.faction_id,
				projectile.damage_base,
				proc_pool
			)
			proj.initialize(member, t)

			projectile.projectile_root.get_parent().add_child(proj)
			pass
	pass
