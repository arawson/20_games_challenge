extends FactionProjectile

# Goes kaboom in place and does a load of damage.

onready var area = get_node(".") as Area2D

func _ready():
	print("rusher explosion attached")
	area.monitoring = true

	var hittables = []

	for b in area.get_overlapping_bodies():
		var target: FactionMember = b
		if (target == null
			or target.faction_id == faction_id
			):
			continue
		hittables.append(target)

	print("have %s targets to hit" % len(hittables))

	for h in hittables:
		var _x = do_proc_on(h)
		print("rusher explosion do damage")
