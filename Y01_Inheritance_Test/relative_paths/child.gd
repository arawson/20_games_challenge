extends Node2D

export(NodePath) var childPath

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var path = "%s" % get_path_to($Child)
	var child_path = "%s" %  childPath
	var abs_path =  "%s" % $Child.get_path()
	
	if $Child == $Child:
		# just checking reference equality real quick
		pass
	pass
