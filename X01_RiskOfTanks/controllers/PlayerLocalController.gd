extends BaseController

var pickup_tracking : ItemPickup = null
onready var pickup_label = $UISeperator/CenterContainer/PickupLabel
onready var item_scanner = $ItemScanner

var camera: OverheadCamera = null

onready var mouse_widget: Node2D = $MouseTransformDecoupler/MouseWidget

func _physics_process(_delta):
	if unit == null:
		return

	if pickup_tracking != null and Input.is_action_just_pressed("interact"):
		inventory.add_item(pickup_tracking)
		NodeUtil.delete(pickup_tracking)
		# let the area 2d handle our delete by sending the signal
		pass
	
	var send_input = Vector2()
	# extracted from TankA / old Player
	# TODO use input_strength instead for controller support
	if Input.is_action_pressed("left"):
		send_input.x -= 1
	if Input.is_action_pressed("right"):
		send_input.x += 1
	if Input.is_action_pressed("forward"):
		send_input.y -= 1
	if Input.is_action_pressed("backward"):
		send_input.y += 1
	unit.set_input_direction(send_input)

	var aim_vector = (mouse_widget.global_position - global_position).normalized()

	if Input.is_action_pressed("fire"):
		_setup_projectiles(unit.trigger_ability(BaseUnit.ABILITY_SLOT.SPACE,aim_vector))

	if Input.is_action_pressed("special"):
		_setup_projectiles(unit.trigger_ability(BaseUnit.ABILITY_SLOT.F, aim_vector))
	
	if Input.is_action_pressed("light"):
		_setup_projectiles(unit.trigger_ability(BaseUnit.ABILITY_SLOT.LMB, aim_vector))


func set_camera(cam: OverheadCamera):
	camera = cam
	cam.set_follow_linear(mouse_widget, 4.0)
	pass

func _on_ItemScanner_area_shape_changed(_area_rid, _area, _area_shape_index, _local_shape_index):
	var items = item_scanner.get_overlapping_areas()
	
	var pickups_in_range = items.size()
	if not pickup_tracking in items and pickups_in_range > 0:
		pickup_tracking = items[0]
	
	if pickups_in_range <= 0:
		pickup_tracking = null
		# TODO shouldn't the gui be attached to signals from the controller?
		gui.hide_pickup_label()
	else:
		gui.set_and_show_pickup_label(pickup_tracking.proc_item)

# func _on_health_change(_old_value, new_value):
# 	gui.set_health(new_value, unit.health_max, 0)

func _on_ability_fired(slot: int, cooldown: float):
	gui.activate_ability(slot, cooldown)

func _on_ability_off_cooldown(slot: int):
	gui.reset_ability(slot)
