extends FactionProjectile

# The time before contact monitoring begins
export(float) var arm_time: float = 0.1

export(float) var lifetime_max: float = 2.5

func _physics_process(delta: float):
	if arm_time >= 0:
		arm_time -= delta
	lifetime_max -= delta
	if lifetime_max <= 0:
		delete_self()


func _on_BasicBullet_body_entered(body):
	if (arm_time > 0):
		return
	if lifetime_max <= 0:
		return
	
	var faction_member = body as FactionMember
	if faction_member != null:
		if faction_member.faction_id != faction_id:
			
			self.proc_pool.trigger_on_hit(body)
			delete_self()
