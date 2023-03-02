extends Resource
class_name FactionAbility

enum Targeting { FREE_AIM = 0, FORWARD }

# The abilities any controlled unit has.

# The default cooldown for the ability. May be modified by items later.
export(float) var base_cooldown = 1.0

# The icon to show in the help and in the GUI to represent the ability.
export(Texture) var icon

# The name of the ability.
export(String) var name

export(Targeting) var targeting_type

export(Script) var bullet_spawn_behavior

export(Resource) var projectile_definition
