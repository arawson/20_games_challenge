class_name ItemPickup
extends Area2D

export(Resource) var proc_item

func _ready():
	assert(proc_item is ProcItem)
	$Icon.texture = proc_item.icon
