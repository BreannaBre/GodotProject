extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 10

	# Handle jump.
	if Input.is_action_pressed("Player1Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#reset hoizontal velocity
	velocity.x = 0
	#direction based on input
	if Input.is_action_pressed("Player1Left"):
		get_node("%Fishcat").flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed("Player1Right"):
		get_node("%Fishcat").flip_h = false
		velocity.x += 1
	velocity.x = velocity.x*SPEED

	move_and_slide()
