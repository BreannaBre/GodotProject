class_name Room
extends Node2D

var target := Vector2(0,0)
var sleep := true
var body: RigidBody2D
var next_shake: int = 0
var breakaway: int = 0

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_sleep(new_sleep: bool) -> void:
	sleep = new_sleep
	if sleep:
		body.gravity_scale = 1
	else:
		body.gravity_scale = 0

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos

func reset_breakaway() -> void:
	breakaway = 0

func fire(_new_target: Vector2) -> void:
	pass

# This sets up defaults for the RigidBody2D, so make sure body has been
# properly assigned!
func defaults() -> void:
	body.lock_rotation = true
	body.linear_damp = 1
	body.collision_layer = 0b1000
	body.collision_mask  = 0b1110

func shake() -> void:
	var cur := Time.get_ticks_msec()
	if cur > next_shake:
		next_shake = cur + randi_range(300, 1000)
		breakaway += 1
		var impulse := Vector2(randf_range(-breakaway, breakaway), randf_range(-breakaway, breakaway))
		body.apply_impulse(impulse)
