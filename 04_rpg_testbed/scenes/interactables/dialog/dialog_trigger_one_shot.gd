extends Node


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


# conceptually this seems ok but
# TODO is this bad usability? what if the player forgets the dialog?
var _activated: bool = false


func activate():
	if _activated:
		return
	Util.show_balloon(dialogue_resource, dialogue_start)
	_activated = true
