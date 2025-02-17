extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = -9.8  # Define gravity explicitly

func _physics_process(delta: float) -> void:
	# Apply gravity.  Do this *before* checking is_on_floor() for more consistent gravity.
	velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle movement.  This is the KEY change.
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:  # Deceleration only when NO input.
		velocity.x = move_toward(velocity.x, 0, SPEED * delta) # Delta is crucial here!
		velocity.z = move_toward(velocity.z, 0, SPEED * delta) # Delta is crucial here!

	move_and_slide()
