class_name Arrow
extends Node2D

var body: RigidBody2D
var angle: float
var pos
const ARROW_SPEED: float = 500

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the arrow nodes")
	body = body_unsafe as RigidBody2D

func set_trans(new_angle: float, pos: Vector2) -> void:
	body.transform = Transform2D(new_angle, pos)
	angle = new_angle

func fire() -> void:
	body.transform
	body.linear_velocity = Vector2(ARROW_SPEED, 0).rotated(angle)
