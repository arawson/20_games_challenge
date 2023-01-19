extends FactionProjectile

# The time before contact monitoring begins
export(float) var arm_time = 0.1

export(float) var lifetime_max = 2.5

func initialize(pool: ProcPool) -> void:
	$Proc.clone_from(pool)
	pass

func _physics_process(delta):
	if arm_time >= 0:
		arm_time -= delta
	lifetime_max -= delta
	if lifetime_max <= 0:
		get_parent().remove_child(self)


func _on_BasicBullet_body_entered(body):
	if (arm_time > 0):
		return
	
	if body is FactionMember:
		if body.faction_id != faction_id:
			$Proc.trigger_on_hit(body)
			pass
		
	get_parent().remove_child(self)

func set_proc_pool(p: ProcPool) -> void:
	self.add_child(p)
