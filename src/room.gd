class_name Room
extends Node2D

var target := Vector2(0,0)
var sleep := true
var body: RigidBody2D

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_sleep(new_sleep: bool) -> void:
	sleep = new_sleep

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos

func fire(_new_target: Vector2) -> void:
	pass
