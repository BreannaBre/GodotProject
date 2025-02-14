class_name Arrow
extends Node2D

var body: RigidBody2D

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the arrow nodes")
	body = body_unsafe as RigidBody2D

func set_trans(angle: float, pos: Vector2) -> void:
	body.transform = Transform2D(angle, pos)

func fire(direction: Vector2, pos: Vector2) -> void:
	body.transform = Transform2D(direction.angle(), pos)
	body.linear_velocity = direction
