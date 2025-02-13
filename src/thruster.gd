class_name Thruster
extends Room

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the thruster nodes")
	body = body_unsafe as RigidBody2D
	var repair_sign_unsafe := get_node("%RepairSign")
	assert(repair_sign_unsafe is Sprite2D, "Somebody's been mucking with the thruster nodes")
	repair_sign = repair_sign_unsafe
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)

func _physics_process(delta: float) -> void:
	if state == ATTACHED or state == REPAIRING:
		# this replaces shake
		thrust(delta)

var shake_dir: int = 80
func thrust(delta: float) -> void:
	var impulse := target - body.global_position
	impulse *= delta * 100
	var cur := Time.get_ticks_msec()
	if cur > next_shake:
		shake_dir *= -1
		next_shake = cur + 70
		impulse += Vector2(shake_dir, 0)
	body.apply_impulse(impulse)
