extends Node2D


@export var turn_order: Array[Faction] = []
var turn_index: int = 0
var faction_by_name: Dictionary = {}


func _ready() -> void:
	assert(turn_order.size() > 0)
	for t in turn_order:
		_register_faction(t)

	turn_order[turn_index].turn_ready()


func _process(_delta: float) -> void:
	pass


func _register_faction(faction: Faction):
	assert(!faction_by_name.has(faction.name))
	faction_by_name[faction.faction_base.name] = faction
	faction.turn_completed.connect(_on_faction_turn_completed)


func _on_faction_turn_completed(faction: String):
	print("_on_faction_turn_completed: %s" % faction)
	assert(faction_by_name.has(faction))
	assert(turn_order[turn_index].faction_base.name == faction)
	turn_index += 1
	if turn_index >= len(turn_order):
		turn_index = 0
	turn_order[turn_index].turn_ready()
