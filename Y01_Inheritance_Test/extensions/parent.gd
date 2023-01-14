extends Node2D

onready var label = $Label

export var flim_flam = "asdf"

func _physics_process(delta):
	label.text = "number of children is %d" % get_child_count()
