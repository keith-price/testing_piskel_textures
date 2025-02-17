extends CharacterBody3D

const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const GRAVITY = -9.8
const MOUSE_SENSITIVITY = 0.1  # Adjust sensitivity as needed

@onready var camera = $Camera3D

func _input(event):
	if event is InputEventMouseMotion:
		# Rotate the character's yaw (horizontal rotation) based on horizontal mouse movement
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		# Rotate the camera's pitch (vertical rotation) based on vertical mouse movement
		camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		# Clamp the camera rotation to prevent flipping
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture the mouse

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Handle jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle movement
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

	move_and_slide()
