class_name Shield
extends Room

@export var force: float = 4
const DIST: float = 230

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the shield nodes")
	body = body_unsafe as RigidBody2D
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)

func _physics_process(delta: float) -> void:
	default_physics_process(delta)

	var enemies := get_tree().get_nodes_in_group("enemies")
	for unsafe_enemy in enemies:
		assert(unsafe_enemy is Enemy, "Don't touch the enemies group please!")
		var enemy := unsafe_enemy as Enemy
		var dist := absf(enemy.body.global_position.x - body.global_position.x)
		if dist > DIST:
			continue
		var force_vec := Vector2((DIST-dist)*force, 0)
		enemy.body.apply_central_force(force_vec)
