extends Node

# Test Scene Script full of garbage and nonsense

func _ready():
	# var source_node = $TeamRed/Enemy2
	# var dest_node = $DynamoProjectile
	# dest_node.source = source_node
	# $DynamoProjectile.destination = $TeamRed/Enemy3
	
	# if this were the real game, some kind of LevelController would setup
	# the level to have the correct controllers and activate the connections
	$TeamBlue/TankA/Player.attach_gui($CanvasLayer/GUI as GUI)

	$OverheadCamera.set_follow_arrive_at_then_instant($TeamBlue/TankA, Vector2(1575,-750), 5.0)
	# $OverheadCamera.set_follow_instant($TeamBlue/TankA)

	pass


func _on_OverheadCamera_camera_reached_target(camera, target):
	if target == $TeamBlue/TankA:
		$TeamBlue/TankA/Player.set_camera(camera)
