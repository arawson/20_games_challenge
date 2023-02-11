extends HFlowContainer

var items: Array = []

var ProcIcon = preload("res://gui/ProcIcon.tscn")

func add_item(item: ProcItem, _quantity, current_quantity):
	var icon = null
	for i in get_children():
		if i.item == item:
			icon = i
			break
	if icon == null:
		icon = ProcIcon.instance()
		icon.item = item
		add_child(icon)

	icon.quantity = current_quantity

func remove_item(item: ProcItem, _quantity, current_quantity):
	var icon = null
	# REALLY missing predicate searches and lambdas right now
	for i in get_children():
		if i.item == item:
			icon = i
			break
	if icon == null:
		return
	
	icon.quantity = current_quantity

	if icon.quantity <= 0:
		remove_child(icon)
