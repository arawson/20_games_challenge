class_name Inventory
extends Node

signal added_item(item, quantity, current_quantity)
signal removed_item(item, quantity, current_quantity)

class ItemEntry:
	var item: ProcItem
	var quantity: int

var items: Array = []

func _ready():
	pass

func add_item(pickup: ItemPickup, quantity: int = 1):
	var entry: ItemEntry = null
	# would be nice to have a predicate search...
	for c in len(items):
		var e = items[c]
		if e.item.pickup_name == pickup.proc_item.pickup_name:
			entry = items[c]
			break
	if entry == null:
		entry = ItemEntry.new()
		entry.item = pickup.proc_item
		entry.quantity = 0
		items.append(entry)
	entry.quantity += 1
	emit_signal("added_item", pickup.proc_item, quantity, entry.quantity)

func remove_item(item: ProcItem, quantity: int = 1):
	var entry: ItemEntry = null
	var index: int = 0
	for c in len(items):
		var e = items[c]
		if e.pickup_name == item.name:
			entry = items[c]
			index = c
			break
	if entry == null:
		return
	entry.quantity -= quantity
	if entry.quantity <= 0:
		items.remove(index)
	emit_signal("removed_item", item, quantity, entry.quantity)

func attach_gui(gui: GUI):
	gui.connect_inventory(self)

func detach_gui():
	# TODO manufacture some way to switch which inventory is being shown
	pass
