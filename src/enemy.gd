class_name Enemy
extends Node2D

var target := Vector2(0,0)
var sleep := true

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_sleep(new_sleep: bool) -> void:
	sleep = new_sleep

func set_pos(_new_pos: Vector2) -> void:
	pass
