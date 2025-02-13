class_name Core
extends Room

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the core nodes")
	body = body_unsafe as RigidBody2D
	var repair_sign_unsafe := get_node("%RepairSign")
	assert(repair_sign_unsafe is Sprite2D, "Somebody's been mucking with the core nodes")
	repair_sign = repair_sign_unsafe
	default_ready()

#func _process(delta: float) -> void:
	#default_process(delta)
#
#func _physics_process(delta: float) -> void:
	#default_physics_process(delta)
