class_name Kernel
extends Room

var body: RigidBody2D

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the kernel nodes")
	body = body_unsafe as RigidBody2D

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos
