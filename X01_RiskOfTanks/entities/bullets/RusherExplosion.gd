extends FactionProjectile

# Goes kaboom in place and does a load of damage.

# This is a "skew extension" pattern. Area2D and FactionProjectile
# both descend from Node2D
onready var area = get_node(".") as Area2D

func _ready():
	$AnimatedSprite.play("default")


func _on_AnimatedSprite_animation_finished():
	NodeUtil.delete(self)


func _on_RusherExplosion_body_entered(body):
	# for some reason, this works but not get_overlapping_bodies
	var target = body as FactionMember
	if target == null or target.faction_id == faction_id:
		return
	
	var _x = do_proc_on(target)
