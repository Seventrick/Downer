extends CharacterBody3D

@export var inventory_data: InventoryData
@export var collectible_inventory_data: CollectibleInventoryData

signal toggle_inventory
#signal colliding_with_interactable
#signal not_colliding

var SPEED
const walk_speed = 2.0 #WAS 2 !!!!!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const sprint_speed = 16.0
var walking = false
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
var gravity = 9.8

var grounded = false


var look_dir: Vector2


#bob variables
const BOB_FREQ = 3.4
const BOB_AMP = 0.02
var t_bob = 0.0


# Define some new variables for dashing
@export var dash_speed: float  # Speed during the dash
@export var dash_duration: float # How long the dash lasts
@export var dash_decel: float  # How long the dash lasts
var is_dashing = false  # To check if currently dashing
var is_decelerating = false
var dash_direction = Vector3.ZERO  # Direction of the dash

@onready var player: CharacterBody3D = $"."
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var orb = $Head/Camera3D/Orb
@onready var orbMesh = $Head/Camera3D/Orb/MeshInstance3D
@onready var lightTimer = $Head/Camera3D/Orb/LightTimer
@onready var playerBody = $BodyCollider
@onready var lightCollision = $"Head/Camera3D/Orb/safe zone/CollisionShape3D"
@onready var OrbSafeZone = $"Head/Camera3D/Orb/safe zone"
@onready var boxCooldown: Timer = $boxCooldown
@onready var step_cast = $StepCast

@export var interaction_distance : float = 2.0
@export var force_strength := 350 # Strength of the force to apply


@onready var inventory_interface = get_parent().get_parent().get_parent().get_node("UI").get_node("InventoryInterface")


func _ready():
	
	lightCollision.set_disabled(true)
	orb.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#LOOK AT LATER TO FIX PLAYER ROTATION BREAKING MOVEMENT
	#orthonormalize()
	
func _unhandled_input(event):
	if !PlayerState.controlLock:
		# remove cursor
		
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
	"""
	if Input.is_action_just_pressed("inventory") and !PlayerState.OPENBOX:
		print("tab")
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("pause"):
		#toggle_pause.emit()
		pass
	"""
		
func _process(_delta):
	
	# Orb mechanics
	
	if Items.useOrb == 1:
		lightCollision.set_disabled(false)
		orb.show()
		Items.timeCheck = 0
		#lightTimer.start()
		
	if Items.useOrb == 0 and Input.is_action_just_pressed("use") and Items.orbs > 0 and !inventory_interface.visible:
		Items.useOrb = 1
		orb.show()
		%orbUp.play()
		lightCollision.set_disabled(false)
		#print("Used!")
	elif Items.useOrb == 1 and Input.is_action_just_pressed("use") and !inventory_interface.visible:
		Items.useOrb = 0
		Items.timeCheck = 0
		orb.hide()
		%orbDown.play()
		lightCollision.set_disabled(true)
		#print("Put away!")
		
	
	if orb.visible == true:
		lightTimer.set_paused(false)
	else:
		lightTimer.set_paused(true)
	
	# turn off collision for orb if light is depleted
	
	if lightTimer.time_left == 0:
		lightCollision.set_disabled(true)
	
	# toggle inventory
	if PlayerState.item_used_succesfully == true:
		PlayerState.item_used_succesfully = false
		toggle_inventory.emit()
	"""
	for item_data in inventory_data.slot_datas:
		if "orb" in item_data.name:
			print("yay!")
	"""
	
	
func _physics_process(delta):
	
	
	if !PlayerState.controlLock and !PlayerState.movementLock:
	# Item interaction
		
		if %SeeCast.is_colliding():
			var target = %SeeCast.get_collider()
			if target != null and target.has_method("orb_pickup"):
				if Input.is_action_just_pressed("interact"):
					target.orb_pickup() # object runs interact function
					$pickupSound.play()
					pickup_orb() # function that adds to singleton
			if target != null and target.has_method("recharge"):
				if Input.is_action_just_pressed("interact"):
					target.recharge()
					lightTimer.start()
			if target != null and target.has_method("interact"):
				if Input.is_action_just_pressed("interact"):
					target.interact()
			if target != null and target.is_in_group("moveables"):
				if Input.is_action_just_pressed("interact") and !PlayerState.OPENBOX:
					apply_force_to_box(target)
					#box
			if target != null and target.is_in_group("items"):
				if Input.is_action_just_pressed("interact"):
					inventory_data.pickup_item_data(target.item_data)
					$pickupSound.play()
					target.queue_free()
			if target != null and target.is_in_group("collectible"):
				if Input.is_action_just_pressed("interact"):
					collectible_inventory_data.pickup_item_data(target.item_data)
					target.queue_free()
			if target != null and target.is_in_group("interactable"):
				#colliding_with_interactable.emit()
				PlayerState.colliding_with_interactable = true
			else:
				PlayerState.colliding_with_interactable = false
				#not_colliding.emit()
		
		"""# Handle Sprint.
		if Input.is_action_pressed("sprint") and %sprintCooldown.is_stopped() == true:
			SPEED = sprint_speed
			%sprintCooldown.start()
		elif not PlayerState.chase:
			SPEED = walk_speed
			%sprintCooldown.stop()"""
		
		var dashLocation = $Head/DashMarker.global_position
		
		#HANDLE DASH
		if Input.is_action_just_pressed("sprint") and %sprintCooldown.is_stopped() == true:
			#start dashing
			is_dashing = true
			dash_direction = (dashLocation - global_position).normalized()  # Set direction
			velocity = dash_direction * dash_speed  # Apply dash speed
			%sprintCooldown.start()  # Start cooldown timer

			# Create a timer to end the dash after the specified duration
			await get_tree().create_timer(dash_duration).timeout
			is_dashing = false  # Reset dashing state
			is_decelerating = true  # Start deceleration
		
		
		# Deceleration phase
		if is_decelerating:
			# Gradually decrease velocity
			velocity = velocity.move_toward(Vector3.ZERO, dash_decel * delta)
		# Stop deceleration if close to zero
			if velocity.length() < 0.1:
				velocity = Vector3.ZERO
				is_decelerating = false  # End deceleration phase
		
		elif not is_dashing and not PlayerState.chase:
			SPEED = walk_speed
			var input_dir = Input.get_vector("left", "right", "up", "down")
			var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				walking = true
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				walking = false
				velocity.x = 0.0
				velocity.z = 0.0
		
		if walking and not PlayerState.chase:
			camera.fov = 75
		
	else:
		walking = false
		velocity.x = 0.0
		velocity.z = 0.0
	# Light Detection
	if %PlayerZone.is_colliding():
		var target = %PlayerZone.get_collider(0)
		#print(target)
		if target != null and target.is_in_group("lightSources"):
			PlayerState.safe = true
			PlayerState.timeCheck = false
			#print("super safe!!!")
	else:
		#print("nope!")
		PlayerState.safe = false #should be false changed to true for testing ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Add the gravity.
	if not is_grounded():
		velocity.y -= gravity * delta
	# Head bob
	t_bob += delta * velocity.length() * float(is_grounded())
	camera.transform.origin = _headbob(t_bob)

	if PlayerState.chase == true:
		walking = false
		camera.fov = 90
		SPEED = 7
	
	
	
	_handle_joypad_camera_rotation(delta, 2)
	
	
	move_and_slide()
	#move(delta);




func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO


func _rotate_camera(sens_mod: float = 1.0) -> void:
	head.rotation.y -= look_dir.x * sens_mod
	camera.rotation.x -= look_dir.y * sens_mod
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


#region new

func move(delta: float):
	
	step_cast.global_position.x = global_position.x + velocity.x * delta
	step_cast.global_position.z = global_position.z + velocity.z * delta
	
	if is_grounded():
		step_cast.target_position.y = -1.0
	else:
		step_cast.target_position.y = -0.45
	
	var query = PhysicsShapeQueryParameters3D.new()
	query.exclude = [self]
	query.shape = step_cast.shape
	query.transform = step_cast.global_transform
	var result = get_world_3d().direct_space_state.intersect_shape(query, 1)
	if !result:
		step_cast.force_shapecast_update()
	
	if step_cast.is_colliding() and velocity.y <= 0.0 and !result:
		global_position.y = step_cast.get_collision_point(0).y
		velocity.y = 0.0
		grounded = true
	else:
		grounded = false
	
	move_and_slide()

func is_grounded() -> bool:
	return grounded or is_on_floor()

#endregion





func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	


func pickup_orb():
	Items.orbs = 1
	Items.useOrb = 1
	lightTimer.start()
	pass
	
func get_box_movement_direction() -> Vector3:
	
	# Calculate the player's facing direction
	var player_direction = -camera.global_transform.basis.z.normalized()
	player_direction.y = 0
	return player_direction
	

func apply_force_to_box(box: RigidBody3D) -> void:
	var direction = get_box_movement_direction()
	var force = direction * force_strength
	if box.boxed == false and boxCooldown.is_stopped():
		if box.is_in_group("moveables"):
			boxCooldown.start()
			box.apply_impulse(force, box.global_transform.origin)
			print(direction)
	if box.boxed == true and Items.screwUsed == true:
		box.queue_free()

func _on_walk_timeout() -> void:
	
	if walking == true:
		$walkSound.play()
	else:
		$walkSound.stop()
