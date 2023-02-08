extends BaseController

var pickup_tracking : Item = null
onready var pickup_label = $UISeperator/CenterContainer/PickupLabel
onready var item_scanner = $ItemScanner

var camera: OverheadCamera = null

func _physics_process(_delta):
	if unit == null:
		return

	if pickup_tracking != null and Input.is_action_just_pressed("interact"):
		NodeUtil.delete(pickup_tracking)
		# does change handle clearing out the pickup? it does!
	
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

	if Input.is_action_just_pressed("fire"):
		_setup_projectiles(unit.trigger_ability_space())

	if Input.is_action_just_pressed("special"):
		_setup_projectiles(unit.trigger_ability_f())
	
	# TODO LMB processing

func set_camera(cam: OverheadCamera):
	camera = cam
	cam.set_follow_linear($MouseTransformDecoupler/MouseWidget, 4.0)
	pass

func _on_ItemScanner_area_shape_changed(_area_rid, _area, _area_shape_index, _local_shape_index):
	var items = item_scanner.get_overlapping_areas()
	
	var pickups_in_range = items.size()
	if not pickup_tracking in items and pickups_in_range > 0:
		pickup_tracking = items[0]
	
	if pickups_in_range <= 0:
		pickup_tracking = null
		gui.hide_pickup_label()
	else:
		gui.set_and_show_pickup_label(pickup_tracking)

func _on_health_change(old_value, new_value):
	gui.set_health(new_value, unit.health_max, 0)
