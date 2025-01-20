extends Node


const StandardBalloon = preload("res://dialog/balloon.tscn")


func show_balloon(dr: DialogueResource, start: String):
	var balloon: Node = StandardBalloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dr, start)
