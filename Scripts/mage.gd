extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity = 0.25

@export_group("Movement")
@export var move_speed = 3.0
@export var acceleration = 4.0
@export var rotation_speed = 15.0
@export var jump_impulse = 5.0

var camera_input_direction = Vector2.ZERO
var last_movement_direction = Vector3.BACK
var gravity = -15

@onready var camera = %Camera_pivot
@onready var cam = %Camera3D
@onready var mage = %Mage

func _input(event):
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event):
	var is_camera_motion = (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta):
	camera.rotation.x += camera_input_direction.y * delta
	camera.rotation.x = clamp(camera.rotation.x, -PI / 6.0, PI / 3.0)
	camera.rotation.y -= camera_input_direction.x * delta
	
	camera_input_direction = Vector2.ZERO
	
	var direction = Input.get_vector("Left","Right","Up","Down")
	var forward = cam.global_basis.z
	var right = cam.global_basis.x
	
	var move_direction = forward * direction.y + right * direction.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity = velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction *
	 move_speed, acceleration * delta)
	velocity.y = y_velocity + gravity * delta
	
	var is_starting_jump = Input.is_action_just_pressed("Jump") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_impulse
	
	move_and_slide()
	
	if move_direction.length() > 0.2:
		last_movement_direction = move_direction
	var target_angle = Vector3.BACK.signed_angle_to(last_movement_direction,Vector3.UP)
	mage.global_rotation.y = lerp_angle(mage.rotation.y, target_angle,
	 rotation_speed * delta)
	
	if is_starting_jump:
		mage.jump()
	#elif not is_on_floor() and velocity.y < 0:
		#mage.fall()
	elif is_on_floor():
		var ground_speed = velocity.length()
		if ground_speed > 0.0:
			mage.running()
		else:
			mage.idle()
