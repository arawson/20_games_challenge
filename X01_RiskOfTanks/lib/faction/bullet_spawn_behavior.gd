class_name BulletSpawnBehavior
extends Node2D
# Derive this and reference the derived class in your FactionAbility


# Spawns the projectiles according to the FactionAbility and returns
# the instances. Also injects them under the Projectiles node.
func _spawn_projectiles((projectile_definition: ProjectileDefinition)) -> Array: # of FactionProjectile instances
	return []


# Returns the approximate angle to lead a moving target.
func _estimate_lead_angle() -> float: # in radians
	return 0.0


# Returns an estimate of whether the target is in range to fire.
func _estimate_is_in_range() -> bool:
	return true

