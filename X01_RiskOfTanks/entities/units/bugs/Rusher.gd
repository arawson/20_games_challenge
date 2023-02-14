extends BaseController

# TODO: Rusher, and other NPCs, don't really have their own proc pools

onready var body = $RusherBody
var target = null

func _ready():
	var container = get_parent() as FactionContainer
	if container != null:
		faction_id = container.faction_id
		body.faction_id =  container.faction_id

func _physics_process(delta):
	if target == null:
		retarget()
	pass

func retarget():
	# 1. get faction
	var faction = FactionUtil.get_faction_container()


func _on_RetargetTimer_timeout():
	retarget()
