extends Node2D


@export var turn_order: Array[Faction] = []
var turn_index: int = 0
var faction_by_name: Dictionary = {}
var turn_counter: int = 1


@onready var gizmos = $Gizmos


func _ready() -> void:
	assert(turn_order.size() > 0)
	assert(gizmos != null)
	assert(gizmos.get_node("CursorStartPos") != null)

	for t in turn_order:
		_register_faction(t)

	_on_turn_top()
	turn_order[turn_index].turn_ready()


func _process(_delta: float) -> void:
	pass


func _register_faction(faction: Faction):
	assert(!faction_by_name.has(faction.name))
	faction_by_name[faction.faction_base.name] = faction
	faction.turn_completed.connect(_on_faction_turn_completed)


func _on_turn_top():
	for f in turn_order:
		f.turn_top(turn_counter)

func _on_faction_turn_completed(faction: String):
	print("_on_faction_turn_completed: %s" % faction)
	assert(faction_by_name.has(faction))
	assert(turn_order[turn_index].faction_base.name == faction)
	turn_index += 1
	if turn_index >= len(turn_order):
		turn_index = 0
		turn_counter += 1
		_on_turn_top()
	turn_order[turn_index].turn_ready.call_deferred()
