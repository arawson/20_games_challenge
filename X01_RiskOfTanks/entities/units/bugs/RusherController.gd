extends BaseController

# TODO: Rusher, and other NPCs, don't really have their own proc pools

var target: FactionMember = null

func _ready():
	var container = owner.get_parent() as FactionContainer
	if container != null:
		faction_id = container.faction_id
		unit.faction_id =  container.faction_id

func _physics_process(_delta):
	# TODO: shouldn't I just be using an "i died" signal?
	if target == null:
		retarget()

	unit.target_vector = target.global_position

# TODO move this into FactionUtil
func retarget():
	var factions = FactionUtil.get_other_faction_containers(faction_id)
	var nearest_target: FactionMember = null
	var nearest_target_d2: float = INF
	
	for faction in factions:
		for node in faction.get_children():
			var faction_member = node as FactionMember
			if faction_member == null:
				continue
			var d2 = global_position.distance_squared_to(faction_member.global_position)
			if d2 < nearest_target_d2:
				nearest_target = faction_member
				nearest_target_d2 = d2
	
	target = nearest_target
	var _e = target.connect("tree_exited", self, "_on_tree_exited_target")

func _on_tree_exited_target():
	target = null

func _on_RetargetTimer_timeout():
	retarget()

# TODO should this go up to BaseController?
func _on_RusherBody_collided_with_enemy(_faction_member: FactionMember):
	# Rusher's are a special type of kamikaze enemy
	# they only fire off their ability when they collide
	# then they die!
	_setup_projectiles(unit.trigger_ability(BaseUnit.ABILITY_SLOT.F, Vector2()))
	NodeUtil.delete(unit)
