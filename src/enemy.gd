class_name Enemy
extends Node2D

var target := Vector2(0,0)
var body: RigidBody2D

# This sets up defaults for the RigidBody2D, so make sure body has been
# properly assigned!
func default_ready() -> void:
	body.gravity_scale = 0
	body.lock_rotation = true
	body.collision_layer = 0b0100
	body.collision_mask  = 0b1100
	add_to_group("enemies")

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos
