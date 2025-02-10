class_name AngryFace
extends Enemy

var body: RigidBody2D
const ACCEL := 50
const SPEED := 10000
const TURN := 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the angry face nodes")
	body = body_unsafe as RigidBody2D

func _physics_process(_delta: float) -> void:
	if sleep:
		return

	# I would comment what this code does, but honestly vector math confuses me.
	# A lot of this was written through guess-and-check lol.
	var speed := body.linear_velocity.length_squared()
	var target_angle := body.linear_velocity.angle_to(target - body.position)
	var heading := body.linear_velocity.normalized()
	var force := Vector2(0,0)

	if speed > SPEED+20:
		force -= heading * ACCEL
	elif speed < SPEED-20:
		force += (target - body.position).normalized() * ACCEL

	# Force applied at a quarter turn from the direction of movement doesn't
	# change speed, only angle.
	if target_angle < -0.2:
		force += heading.rotated(-0.5 * PI) * TURN
	elif target_angle > 0.2:
		force += heading.rotated(0.5 * PI) * TURN

	body.apply_central_force(force)

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos
