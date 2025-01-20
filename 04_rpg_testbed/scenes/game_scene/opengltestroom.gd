extends Node2D


func _ready() -> void:
	DialogueManager.show_example_dialogue_balloon(load("res://dialog/opengltestroom.dialogue"), "ready")
