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
	pass
