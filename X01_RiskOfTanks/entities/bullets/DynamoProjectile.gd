extends FactionProjectile

var source : Node2D
var destination : Node2D
var length : float

func _ready():
	length = $White2.texture.get_height() * $White2.scale.y
	pass

func _process(_delta):
	if source == null or destination == null:
		return
	
	# rotate to be between 2 nodes
	# put in middle of 2 nodes
	# scale to correct size
	
	var start = source.get_global_transform().origin
	var end = destination.get_global_transform().origin
	var center: Vector2 = Vector2((start.x + end.x) / 2, (start.y + end.y) / 2)
	var angle_to : float = start.angle_to_point(end) + (PI/2)
	var distance : float = start.distance_to(end)
	var scale_to : float = distance / length

	position = center
	rotation = angle_to
	scale.y = scale_to
	
	# transform = Transform2D().scaled(Vector2(scale, scale)).rotated(angle).translated(center)
	
