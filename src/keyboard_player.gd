extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

var sprite: Sprite2D

func _ready() -> void:
	var sprite_node := get_node("%Fishcat")
	assert(sprite_node is Sprite2D, "Player sprite was not Sprite2D")
	sprite = sprite_node as Sprite2D

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
		sprite.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed("Player1Right"):
		sprite.flip_h = false
		velocity.x += 1
	velocity.x = velocity.x*SPEED

	move_and_slide()
