class_name HeartBurn
extends Enemy

const ACCEL := 50
const SPEED := 10000
const TURN := 60
const EXPLODE_FORCE := 1
const DAMAGE_MULT := 0.1
const STOP_DIST = 500

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the heart burn nodes")
	body = body_unsafe as RigidBody2D
	default_ready()

func _physics_process(_delta: float) -> void:
	# I would comment what this code does, but honestly vector math confuses me.
	# A lot of this was written through guess-and-check lol.
	var speed := body.linear_velocity.length_squared()
	var target_angle := body.linear_velocity.angle_to(target - body.position)
	var heading := body.linear_velocity.normalized()
	var force := Vector2(0,0)

	if target.distance_to(body.position) < STOP_DIST or speed > SPEED+20:
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
