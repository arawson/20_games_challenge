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
			var proj = projectile_scene.instance()
			proj.initialize(member, t)
			
			# take this up into Procable as a helper function
			proj.proc_pool = ProcPool.new()
			proj.proc_pool.clone_from(updated_proc_pool)
			# TODO UMM how do we get faction_id through? proj.faction_id = faction_id

			projectile.projectile_root.get_parent().add_child(proj)
			pass
	pass
