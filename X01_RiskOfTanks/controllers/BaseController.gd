extends Node2D
class_name BaseController

export(int) var faction_id = 0

export(NodePath) var unit_path
onready var unit: BaseUnit = get_node(unit_path) as BaseUnit

export(NodePath) var proc_pool_path
onready var proc_pool: ProcPool = get_node(proc_pool_path) as ProcPool

export(NodePath) var projectile_pool_path
onready var projectile_pool: Node = get_node(projectile_pool_path)

export(NodePath) var inventory_path
onready var inventory: Inventory = get_node(inventory_path) as Inventory

func _ready():
	assert(unit != null)
	assert(projectile_pool != null)
	assert(proc_pool != null)
	assert(inventory != null)

func attach_gui(gui: GUI) -> void:
	if unit == null:
		return
	
	gui.connect_health_bar(unit)
	gui.connect_abilities(unit)

# might be unnecessary
func detach_gui(gui: GUI) -> void:
	gui.clear_ability_buttons()

func _setup_projectile(proj):
	# step 0, add to tree to get it ready
	projectile_pool.add_child(proj)
	# step 1, copy our proc pool
	var new_proc_pool = proc_pool.duplicate(DUPLICATE_SCRIPTS)
	# why is get_proc_pool getting called here, on a set operation?
	proj.set_proc_pool(new_proc_pool)
	# proj.proc_pool = new_proc_pool
	# print(proc_pool.get_instance_id())
	# print(new_proc_pool.get_instance_id())
	# For some reason, proc_pool and new_proc_pool share the same path but
	# will have different IDs. Very strange.
	proj.faction_id = faction_id
	pass

func _setup_projectiles(projs: Array):
	for p in projs:
		if p == null:
			continue
		_setup_projectile(p)
