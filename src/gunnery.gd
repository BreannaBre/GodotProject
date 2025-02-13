class_name Gunnery
extends Room

var gun_picture: Sprite2D
const GUN_SCALE := Vector2(0.304, 0.304)

func _ready() -> void:
	var gun_picture_unsafe := get_node("%GunPicture")
	assert(gun_picture_unsafe is Sprite2D, "Somebody's been mucking with the gunnery nodes")
	gun_picture = gun_picture_unsafe as Sprite2D
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the gunnery nodes")
	body = body_unsafe as RigidBody2D
	var repair_sign_unsafe := get_node("%RepairSign")
	assert(repair_sign_unsafe is Sprite2D, "Somebody's been mucking with the gunnery nodes")
	repair_sign = repair_sign_unsafe
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)
	if state == ATTACHED or state == REPAIRING:
		var new_rotation := body.transform.origin.angle_to_point(target)
		gun_picture.transform = Transform2D(new_rotation, GUN_SCALE, 0, Vector2(0,0))
		

func _physics_process(delta: float) -> void:
	default_physics_process(delta)
