class_name ProjectileDefinition
extends Resource

enum Homing {
	NONE = 0,
	# Moves directly towards the target, like magnets.
	DIRECT,
	# Steers towards the target, like missiles.
	STEERED
}

# The scene to be spawned by the BulletSpawnBehavior
export(PackedScene) var scene

# What type of homing to use.
export(Homing) var homing_type

# How fast the projectile goes by default, in px/s.
export(float) var speed_base

# How far homing projectiles pick up on a target, in px.
export(float) var homing_lockon_distance

# How fast steered homing projectiles lock in on targets, in rad/s.
export(float) var homing_steer_speed

# How long to keep the projectile in the scene before self-deleting.
# The main purpose of this is for performance.
export(float) var lifetime_base

# How long it takes a projectile to become active after being spawned.
export(float) var armtime_base

# How much extra wiggle-room to use when spawning away from the launching
# entity's hitbox.
# The "chonk-factor".
export(float) var exclusion_radius
