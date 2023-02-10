class_name Inventory
extends Node

# An inventory needs:
# 1. A dictionary of keys
# 2. Each key maps to a resource
# 3. Those resources each have a "count" to track how many of that object are there
# 4. Methods going in to add and remove items from the inventory
# 5. Signals going out to notify of inventory changed

var items: Array = []

export(NodePath) var proc_pool_path
onready var proc_pool: ProcPool = get_node(proc_pool_path) as ProcPool

var gui: GUI



func _ready():
	assert(proc_pool != null)

func add_item(pickup: ItemPickup):
	if gui != null:
		# TODO shouldn't the gui just be connected to the signals of the inventory
		pass
	pass

func attach_gui(g: GUI):
	gui = g

func detach_gui():
	gui = null
	pass
