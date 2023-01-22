extends Procable

func _ready():
	pass

func is_on_hit() -> bool:
	return true
	
func is_on_kill() -> bool:
	return false

func roll_on_hit(_faction_projectile, _faction_member: FactionMember, _proc_pool) -> bool:
	# Normally, you would want a probability to roll here
	return true

func do_on_hit(projectile: FactionProjectile, member: FactionMember, _new_proc_pool) -> void:
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
	var targets = Util.random_pick(2, hittables)

	for t in targets:
		print("hitting target: %s" % t)
		
	pass
