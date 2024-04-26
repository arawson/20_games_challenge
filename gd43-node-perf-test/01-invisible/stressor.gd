extends Sprite2D


var sub_count: int = 0
var sub_stressor = preload("res://01-invisible/sub_stressor.tscn")


func _ready() -> void:
	for _i in range(sub_count):
		var new_node = sub_stressor.instantiate()
		self.add_child(new_node)
		new_node.do_thing.connect(thing_done)


func thing_done(value: float):
	pass
