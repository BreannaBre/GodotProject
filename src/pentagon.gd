class_name Pentagon
extends Room

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the pentagon nodes")
	body = body_unsafe as RigidBody2D
	defaults()

func _physics_process(_delta: float) -> void:
	if sleep:
		return
	shake()
