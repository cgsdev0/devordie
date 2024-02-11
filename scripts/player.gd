extends CharacterBody3D


const SPEED = 12.0
const JUMP_VELOCITY = 9.0

var picked
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var inside = false

func disable_collider():
	self.set_collision_layer_value(1, false)

func enable_collider():
	self.set_collision_layer_value(1, false)
	$RemoteTransform3D.rotation = Vector3.ZERO
	
func activate_camera():
	$RemoteTransform3D.active = true
	
func _ready():
	floor_snap_length = 1.0
	floor_max_angle = 0.9 # 0.785398

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	activate_camera()

var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

func get_camera():
	return $RemoteTransform3D
	
func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
		
func _update_mouselook():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if !$RemoteTransform3D.active:
		return
	_mouse_position *= GameState.sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking up/down too far
	_total_pitch += pitch
	_total_pitch = clamp(_total_pitch, -90.0, 90.0)

	rotate_y(deg_to_rad(-yaw))
	$RemoteTransform3D.rotation = Vector3.ZERO
	$RemoteTransform3D.rotate_object_local(Vector3(1,0,0), deg_to_rad(-_total_pitch))

	
func _process(delta):
	_update_mouselook()
	if !$RemoteTransform3D.active:
		return
		
	pick_things()
	if Input.is_action_just_pressed("click"):
		if picked:
			%MainCake.do_thing(picked, "left", who)
	elif Input.is_action_just_pressed("rclick"):
		if picked:
			%MainCake.do_thing(picked, "right", who)
		
	var fly_hack = OS.is_debug_build() && Input.is_key_pressed(KEY_SHIFT)
	
	# Add the gravity.
	if not is_on_floor()  && !fly_hack:
		velocity.y -= gravity * delta

	var speed_modifier = 0.8
	
	if fly_hack:
		speed_modifier = 10.0
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_modifier
		velocity.z = direction.z * SPEED * speed_modifier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var space_state = get_world_3d().direct_space_state
	
	var prev = global_transform.origin
	move_and_slide()

#	var dest = global_transform.origin
#	dest.y = -1
#	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, dest)
#	var result = space_state.intersect_ray(query)
#	var angle = 10
#	if result:
#		angle = result.normal.angle_to(Vector3.UP)
#	if angle > 0.8:
#		global_transform.origin = prev


func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == self:
		%CakeCam.show()


func _on_area_3d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == self:
		%CakeCam.hide()

var who
func pick_things():
	if $RemoteTransform3D/RayCast3D.is_colliding():
		picked = $RemoteTransform3D/RayCast3D.get_collider().name
		who = $RemoteTransform3D/RayCast3D.get_collider()
		%Crosshair/Frosting.hide()
		%Crosshair/CakeType.hide()
		%Crosshair/Serve.hide()
		if picked.begins_with("Color"):
			%Crosshair/Frosting.show()
		elif picked.begins_with("BaseCake"):
			%Crosshair/CakeType.show()
		elif picked.begins_with("Table"):
			%Crosshair/Serve.show()
		%Crosshair.show()
	else:
		%Crosshair.hide()
		who = null
		picked = null
