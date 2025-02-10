class_name Gunnery
extends Room

var gun_picture: Sprite2D
const GUN_SCALE := Vector2(0.6, 0.6)

func _ready() -> void:
	var gun_picture_unsafe := get_node("%GunPicture")
	assert(gun_picture_unsafe is Sprite2D, "Somebody's been mucking with the gunnery nodes")
	gun_picture = gun_picture_unsafe as Sprite2D
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the gunnery nodes")
	body = body_unsafe as RigidBody2D

func _process(_delta: float) -> void:
	if sleep:
		return
	var new_rotation := body.transform.origin.angle_to_point(target)
	gun_picture.transform = Transform2D(new_rotation, GUN_SCALE, 0, Vector2(0,0))
