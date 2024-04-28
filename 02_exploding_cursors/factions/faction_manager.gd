extends Node


var factions: Dictionary = {}


func _ready() -> void:
	pass


func register(faction: Faction):
	assert(!factions.has(faction.name))
	factions[faction.name] = faction

func _process(_delta: float) -> void:
	pass
