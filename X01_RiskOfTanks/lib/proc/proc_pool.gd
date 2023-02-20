class_name ProcPool
extends Node2D

# A proc pool contains all of the items which can proc
# TODO: Document why ProcPool extends Node2D instead of Node

# TODO: setup proc pool to listen to inventory signals to manage its procs!

var proc_on_hit: Array = []
var proc_on_kill: Array = []
var procs: Array = []


# I'm going to do this through the UI, but I'm writing it out to understand the
# functionality around it
func connect_to_inventory(inventory: Inventory):
	disconnect_from_inventory()
	var _e
	_e = inventory.connect("added_item", self, "add_item")
	_e = inventory.connect("removed_item", self, "remove_item")

func disconnect_from_inventory():
	NodeUtil.disconnect_incoming_connections(self)

func add_item(item: ProcItem, quantity: int = 1, current_quantity: int = -1):
	var proc: Procable = null
	for p in procs:
		if p.item == item:
			proc = p
			proc.quantity += quantity
			break
	if proc == null:
		proc = item.procable_scene.instance()
		proc.item = item
		proc.quantity = current_quantity if current_quantity > 0 else 1
		add_child(proc)
		procs.append(proc)
		if proc.is_on_hit():
			proc_on_hit.append(proc)
		if proc.is_on_kill():
			proc_on_kill.append(proc)
	
	if proc.quantity != current_quantity and current_quantity > 0:
		proc.quantity = current_quantity

func remove_item(item: ProcItem, quantity: int = 1, current_quantity: int = -1):
	var proc: Procable = null
	for p in procs:
		if p.item == item:
			proc = p
			break
	if proc == null:
		return
	
	proc.quantity -= quantity
	if proc.quantity != current_quantity and current_quantity > 0:
		proc.quantity = current_quantity
	if proc.quantity > 0:
		return

	if proc in get_children():
		remove_child(proc)
	procs.erase(proc)
	proc_on_hit.erase(proc)
	proc_on_kill.erase(proc)


func _ready() -> void:
	refresh_procables()
	
func clear() -> void:
	for p in get_children():
		remove_child(p)
		p.queue_free()
	refresh_procables()
	
func clone_from(pool) -> void:
	for p in pool.get_children():
		# var c = p.clone()
		var c = p.duplicate(DUPLICATE_SCRIPTS)
		# WTF? duplicate is really buggy!
		c.item = p.item
		add_child(c)
	refresh_procables()

func refresh_procables() -> void:
	procs = []
	proc_on_hit = []
	proc_on_kill = []
	for p in get_children():
		if not p is Procable:
			continue
		procs.append(p)
		if p.is_on_kill():
			proc_on_kill.append(p)
		if p.is_on_hit():
			proc_on_hit.append(p)
	
	

func trigger_on_hit(faction_projectile, faction_member: FactionMember):
	print("procing on hit")
	var activated_procs = [] # keep track of which procs fired this time
	for proc in proc_on_hit:
		if not proc.is_consumed and proc.roll_on_hit(faction_projectile, faction_member, self):
			activated_procs.append(proc)
	
	for proc in activated_procs:
		proc.is_consumed = 1
	
	var new_pool = self.duplicate(DUPLICATE_SCRIPTS)
#	new_pool.clone_from(self)

	for proc in activated_procs:
		proc.do_on_hit(faction_projectile, faction_member, new_pool)
	
func trigger_on_kill(faction_projectile, faction_member: FactionMember):
	print("procing on kill")
	# one instance of duplication for this isn't so bad
	var activated_procs = []
	for proc in proc_on_kill:
		if not proc.is_consumed and proc.roll_on_kill(faction_projectile, faction_member, self):
			activated_procs.append(proc)
	
	for proc in activated_procs:
		proc.is_consumed = 1
	
	var new_pool = self.duplicate(DUPLICATE_SCRIPTS)

	for proc in activated_procs:
		proc.do_on_kill(faction_projectile, faction_member, new_pool)
