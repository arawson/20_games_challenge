class_name Unit
extends Node


@export var base: UnitBase


var faction: Faction
var blocks: Array[UnitBlock] = []


func _ready() -> void:
	assert(base != null)
