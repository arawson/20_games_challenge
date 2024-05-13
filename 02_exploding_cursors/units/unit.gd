class_name Unit
extends Node


@export var base: UnitBase


var faction: Faction
var blocks: Array[UnitBlock] = []
var health: int = 1
var movement_left: int
var actions_left: int


const block_scene = preload("res://units/unit_block.tscn")


func _ready() -> void:
	assert(base != null)
	# we can't mamke this assertion because the map load sequence assembles
	# units out of their blocks by name
	# assert(len(blocks) > 0) 


func turn_ready() -> void:
	movement_left = base.move_speed
	actions_left = 1


func get_head() -> UnitBlock:
	for b in blocks:
		if b.is_head == true:
			return b

	assert(false, "headless unit")
	return null


func make_block() -> UnitBlock:
	var block = block_scene.instantiate()
	block.unit = self
	block.unit_base = base
	block.faction = faction
	block.is_head = false
	block.name = "%s_%s" % [name, faction.turn_number]
	block.turn_created = faction.turn_number
	return block


func get_block_on(coords: Vector2i) -> UnitBlock:
	for b in blocks:
		if b.coords == coords:
			return b
	return null


func get_damage_block() -> UnitBlock:
	return blocks.back()


func move_head(dir: Util.Direction):
	var head = get_head()
	var old_head_coords = head.coords
	var old_head_pos = head.global_position
	var new_head_coords = head.coords + Util.displacementi(dir)

	var conflict = get_block_on(new_head_coords)
	if conflict != null:
		# then swap head with that block
		faction.map_controller.detach_block(head)
		faction.map_controller.detach_block(conflict)
		faction.map_controller.attach_block(head, new_head_coords)
		faction.map_controller.attach_block(conflict, old_head_coords)
		conflict.turn_created = faction.turn_number

	else:
		faction.map_controller.detach_block(head)
		faction.map_controller.attach_block(head, new_head_coords)

		var filler = make_block()
		blocks.insert(1, filler)
		faction.map_controller.attach_block(filler, old_head_coords)
		filler.reinit()
		health += 1

		# get rid of the oldest block if we have more blocks than health
		if health > base.health_max:
			var deletable = get_damage_block()
			faction.map_controller.detach_block(deletable)
			deletable.queue_free()
			health -= 1

	MainBus.unit_moved.emit(self, dir, old_head_pos)
