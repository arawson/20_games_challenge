extends FactionProjectile

var source : Node2D

# The target of the lightning effect. We will proc this one after the effect times out.
var destination : Node2D

var length : float

func initialize(src: Node2D, dest: Node2D):
	self.source = src
	self.destination = dest

func _ready():
	# TODO this could be made static
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

func _on_Timer_timeout():
	# doing the proccing on timeout, more for fun than anything else.

	var _thunk = do_proc_on(destination)

	NodeUtil.delete(self)
