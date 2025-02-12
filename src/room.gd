class_name Room
extends Node2D

var target := Vector2(0,0)
var sleep := true
var body: RigidBody2D
var next_shake: int = 0
var breakaway: int = 0
var tube: RID

# This sets up defaults for the RigidBody2D, so make sure body has been
# properly assigned!
func defaults() -> void:
	body.lock_rotation = true
	body.linear_damp = 1
	body.collision_layer = 0b1000
	body.collision_mask  = 0b1100
	tube = PhysicsServer2D.joint_create()

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_sleep(new_sleep: bool) -> void:
	sleep = new_sleep
	if sleep:
		body.gravity_scale = 1
	else:
		body.gravity_scale = 0

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos

func pop_off() -> void:
	breakaway = 0
	set_sleep(true)
	PhysicsServer2D.joint_clear(tube)

func pop_on(host: RigidBody2D) -> void:
	set_sleep(false)
	# I'm still not entirely sure how this stuff works ;-;
	PhysicsServer2D.joint_make_damped_spring(tube, body.global_position, host.global_position, host, body)
	PhysicsServer2D.damped_spring_joint_set_param(tube, PhysicsServer2D.DAMPED_SPRING_REST_LENGTH, 0)
	PhysicsServer2D.damped_spring_joint_set_param(tube, PhysicsServer2D.DAMPED_SPRING_STIFFNESS, 10)

func fire(_new_target: Vector2) -> void:
	pass

func shake() -> void:
	var cur := Time.get_ticks_msec()
	if cur > next_shake:
		next_shake = cur + randi_range(10000/(breakaway+1), 50000/(breakaway+1))
		breakaway += 1
		var impulse := Vector2(randf_range(-breakaway, breakaway), randf_range(-breakaway, breakaway))
		body.apply_impulse(impulse)
