extends FactionProjectile

# The time before contact monitoring begins
export(float) var arm_time: float = 0.1

export(float) var lifetime_max: float = 2.5

func _physics_process(delta: float):
	if arm_time >= 0:
		arm_time -= delta
	lifetime_max -= delta
	if lifetime_max <= 0:
		NodeUtil.delete(self)


func _on_BasicBullet_body_entered(body):
	if (arm_time > 0):
		return
	if lifetime_max <= 0:
		return
	
	# var faction_member = body as FactionMember
	# if faction_member != null:
	# 	if faction_member.faction_id != faction_id:
			
	# 		if faction_member.do_damage(damage_base):
	# 			self.proc_pool.trigger_on_kill(self, faction_member)

	# 		self.proc_pool.trigger_on_hit(self, faction_member)
	if do_proc_on(body):
		NodeUtil.delete(self)
