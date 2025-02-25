class_name Enemy
extends Node2D

var target := Vector2(0,0)
var body: RigidBody2D

func default_ready() -> void:
	body.gravity_scale = 0
	body.lock_rotation = true
	body.collision_layer = 0b0000_0100
	body.collision_mask  = 0b0001_1000
	add_to_group("enemies")

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos
