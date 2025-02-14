class_name Flame
extends Node2D

var body: RigidBody2D
const DAMAGE := 10.0

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the flame nodes")
	body = body_unsafe as RigidBody2D

func _on_body_entered(other: Node) -> void:
	var room := other.get_parent()
	assert(room is Room, "Collided with something that's not a room")
	(room as Room).damage(DAMAGE)
	queue_free()
