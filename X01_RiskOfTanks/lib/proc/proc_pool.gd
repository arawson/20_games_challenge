class_name ProcPool
extends Node2D

# A proc pool contains all of the items which can proc

var proc_on_hit = []
var proc_on_kill = []

func initialize() -> void:
	for p in get_children():
		remove_child(p)
	
	proc_on_hit = []
	proc_on_kill = []
	
func clone_from(pool) -> void:
	initialize()
	for p in pool.get_children():
		var c = p.clone()
		register_procable(c)
	pass

func register_procable(p: Procable) -> void:
	if p == null: return
	if not p in get_children(): add_child(p)
	
	if p.is_on_hit() and not p in proc_on_hit:
		proc_on_hit.append(p)
	
	if p.is_on_kill() and not p in proc_on_kill:
		proc_on_kill.append(p)
	
func remove_procable(p: Procable) -> void:
	if p == null: return
	if p in get_children(): remove_child(p)
	
	while p in proc_on_hit:
		proc_on_hit.remove(proc_on_hit.find(p))
		
	while p in proc_on_kill:
		proc_on_kill.remove(proc_on_kill.find(p))
	

func trigger_on_hit(faction_member: FactionMember):
	print("procing on hit")
	var activated_procs = [] # keep track of which procs fired this time
	for proc in proc_on_hit:
		if not proc.is_consumed and proc.roll_on_hit(faction_member, self):
			
			activated_procs.append(proc)
	
	for proc in activated_procs:
		proc.is_consumed
		# remove which would be really slow, it'll be a
	
	# loop again
	
func trigger_on_kill():
	print("procing on kill")
