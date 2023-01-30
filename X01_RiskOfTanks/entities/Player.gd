extends FactionMember

var speed_max = 300.0
var turn_max = 3.0

var turn = 0.0
var velocity = Vector2()

onready var projectiles = $Projectiles
# these are kept up to date
onready var current_proc_pool = $CurrentProcPool
onready var basic_bullet_scene = load("res://entities/bullets/BasicBullet.tscn")
onready var missile_scene = load("res://entities/bullets/Missile.tscn")

var pickup_tracking : Item = null
onready var pickup_label = $UISeperator/CenterContainer/PickupLabel
onready var item_scanner = $ItemScanner

export(NodePath) var gui_path
onready var gui = get_node(gui_path)

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("left"):
		turn -= turn_max * delta
	if Input.is_action_pressed("right"):
		turn += turn_max * delta
	
	if Input.is_action_pressed("forward"):
		velocity.y = -speed_max
	if Input.is_action_pressed("backward"):
		velocity.y = +speed_max
	
	velocity = velocity.rotated(turn)
		
	rotation = turn
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("fire"):
		var bullet = basic_bullet_scene.instance()
		projectiles.add_child(bullet)
		
		bullet.global_position = self.global_position + 20*Vector2(0,-1).rotated(turn)
		bullet.rotation = self.rotation
		bullet.linear_velocity = bullet.linear_velocity.rotated(turn)

		_setup_projectile(bullet)
		# TODO document this: bullet.proc_pool.visible = true # THIS CALLS THE SETTER?
		# bullet.get_proc_pool().visible = true # explicitly use the getter to work around the above
		pass

	if Input.is_action_just_pressed("special"):
		var missile = missile_scene.instance()
		projectiles.add_child(missile)

		missile.global_position = self.global_position + 30*Vector2(0,-1).rotated(turn)
		missile.angle = self.rotation - (PI/2) # crud, I've mixed up this terminology TODO write this up as a lesson for future games
		_setup_projectile(missile)
	
	if pickup_tracking != null and Input.is_action_just_pressed("interact"):
		
		Util.delete_node(pickup_tracking)
		# does change handle clearing out the pickup? it does!
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

