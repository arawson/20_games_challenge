class_name ProcableDamage
extends Procable

# TODO replace float damage with a DamageBuilder
# TODO base damage doesn't belong on an item
export(float) var damage_base = 10.0

func clone_from(procable):
	# WTF? base classes are really buggy...
	# WTF? Method overriding doesn't work?
	.clone_from(procable)
	print ("procable damage clone")
	damage_base = procable.damage_base
