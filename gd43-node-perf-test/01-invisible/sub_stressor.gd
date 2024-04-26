extends Node


signal do_thing(value: float)
var value: float = 42.0


func do_thing_thing():
	do_thing.emit(value)
