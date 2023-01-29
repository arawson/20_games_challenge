class_name KinematicFactionProjectile
extends KinematicBody2D

# KinematicFactionProjectile wraps the functionality of the standard
# FactionProjectile

# The biggest limiation of this approach is that it is not possible to use the
# `as` keyword to check for both of these projectile type hierarchies at the
# same time. This is a time where interfaces come in handy.

# Design Flaw: it almos makes more sense for the faction projectile to be
# kinematic by default. However, that doesn't let us make the existing bouncy
# bullets very nicely.

export(NodePath) var faction_projectile_path
onready var faction_projectile: FactionProjectile = get_node(faction_projectile_path)

# TODO recreating a var, would like a better solution
# can't make an export var with setters and getters (probably for editor support reasons)
export(int) var faction_id = 0

var proc_pool: ProcPool setget set_proc_pool, get_proc_pool

func _ready():
	# this will be buggy if things ever switch factions
	pass

func set_proc_pool(p: ProcPool) -> void:
	faction_projectile.set_proc_pool(p)

func get_proc_pool() -> ProcPool:
	return faction_projectile.get_proc_pool()

func do_proc_on(body) -> bool:
	# ran into a bug on the first projectile, ugh what a bandaid
	faction_projectile.faction_id = faction_id
	return faction_projectile.do_proc_on(body)
