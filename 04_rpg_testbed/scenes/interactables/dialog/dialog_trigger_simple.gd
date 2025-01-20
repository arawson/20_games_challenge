extends Node


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


func activate():
	Util.show_balloon(dialogue_resource, dialogue_start)
