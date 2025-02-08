extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	#reset velocity
	velocity = Vector2(0,0)
	#move based on input
	if Input.is_action_pressed("Player1Left"):
		velocity.x -= 1
	if Input.is_action_pressed("Player1Right"):
		velocity.x += 1
	velocity.x = velocity.x*SPEED
	
	move_and_collide(velocity * delta)
