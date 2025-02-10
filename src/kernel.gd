class_name Kernel
extends Room

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the kernel nodes")
	body = body_unsafe as RigidBody2D
