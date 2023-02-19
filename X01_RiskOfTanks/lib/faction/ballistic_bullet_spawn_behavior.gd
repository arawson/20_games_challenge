extends BulletSpawnBehavior


func _spawn_projectiles(\
	faction_ability: FactionAbility,\
	projectile_definition: ProjectileDefinition,\
	unit: BaseUnit,\
	projectile_pool: Node,\
	aim_vector: Vector2\
) -> Array: # of FactionProjectile instances
	var aim_angle = (
		unit.global_rotation
		if faction_ability.targeting_type == FactionAbility.Targeting.FORWARD
		else aim_vector.angle()
	)
	var launch_position = (
		unit.global_position
		+ (projectile_definition.exclusion_radius + unit._get_exclusion_radius())
			* Vector2.RIGHT.rotated(aim_angle)
	)
	var shot = projectile_definition.scene.instance() as FactionProjectile
	
	assert(shot != null)
	
	shot.set_angle(aim_angle)
	shot.set_position(launch_position)
	
	return [shot]


# Returns the approximate angle to lead a moving target.
func _estimate_lead_angle(\
	unit_self: BaseUnit,\
	unit_target: BaseUnit,\
	faction_ability: FactionAbility,\
	projectile_definition: ProjectileDefinition\
) -> float: # in radians
	# var estimated_target = unit_target.global_position + unit_target._get_velocity() * travel_time
	var angle_base = unit_self.global_position.angle_to_point(unit_target.global_position)
	# TODO brush up on the mathematics needed to do this estimation
	return angle_base


# Returns an estimate of whether the target is in range to fire.
func _estimate_is_in_range(\
	unit_self: BaseUnit,\
	unit_target: BaseUnit,\
	faction_ability: FactionAbility,\
	projectile_definition: ProjectileDefinition\
) -> bool:
	var max_distance_2 = pow(projectile_definition.speed_base * projectile_definition.lifetime_base, 2)
	var distance = unit_self.global_position.distance_squared_to(unit_target.global_position)
	return distance <= max_distance_2
