class_name UnitStateMachine
extends StateMachine

export(NodePath) var unit_path
onready var unit: BaseUnit = get_node(unit_path) as BaseUnit

export(NodePath) var controller_path
onready var controller: BaseController = get_node(controller_path) as BaseController

func _ready():
	for child in get_children():
		if not child is UnitState:
			continue
		child.unit = unit
		child.controller = controller
