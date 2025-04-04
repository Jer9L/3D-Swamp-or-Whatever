extends CharacterBody3D

const SPEED = 1.0 #скорость 
const RUN_SPEED = 2.5 #скорость бега
const JUMP_VELOCITY = 3 #сила прыжка

@onready var camera = $Y/X/Camera_location/Camera3D #сокращение камеры
@onready var camera_collider = $Y/X/Camera_location/RayCast3D #сокращение рейкаста
@onready var menu = $"../CanvasLayer/Game_menu"

var walking = false #переключатель звука

func _process(delta): #столкновение камеры и звуки всякие
	if camera_collider.is_colliding(): #если луч сталкивается, то камера перемещается
		camera.global_transform.origin = camera_collider.get_collision_point() 
	else: camera.position.z = 80 #иначе камера возвращается

	if walking == true: #если идём, то идём
		$Walk_SFX.play()
	else: $Walk_SFX.playing = false #иначе не идём

func _physics_process(delta): #физический процесс
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		char_rotation()
		walking = true #звуки шагов работают
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		walking = false #звуки шагов !работают

	velocity = velocity.rotated(Vector3(0,1,0), $Y.rotation.y)

	move_and_slide()
	Low_Budget_Animation()

func Low_Budget_Animation(): #низкобюджетные анимации
	if not is_on_floor():
		$AuxScene/AnimationPlayer.play("Jump0")
	elif velocity.x != 0 or velocity.z != 0:
		$AuxScene/AnimationPlayer.play("Walking0")
	else:
		$AuxScene/AnimationPlayer.play("StandingIdle0")

func _input(event): #действия чекаем, ага
	if event is InputEventMouseMotion and menu.visible == false: #если мы мышь тыкаем палкой
		$Y.rotation.y -= event.relative.x * 0.005 #крутим по Y
		$Y/X.rotation.x -= event.relative.y * 0.005 #крутим по Х
	if Input.is_action_just_pressed("ui_cancel"):
		menu.visible = !menu.visible
		if menu.visible == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func char_rotation(): #вращение персонажа
	$AuxScene.rotation.y = $Y.rotation.y

func _ready(): #хотите фокус? Мышка испарилась!
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
