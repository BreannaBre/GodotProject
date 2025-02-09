class_name GunRoom
extends Node2D


var gun_picture:Sprite2D
const GUN_SCALE := Vector2(0.6, 0.6)


func _ready() -> void:
	gun_picture = get_node("%GunPicture")

func _process(_delta: float) -> void:
	pass

func train(rotation: float) -> void:
	gun_picture.transform = Transform2D(rotation, GUN_SCALE, 0, Vector2(0,0))

func fire(rotation: float) -> void:
	gun_picture.transform = Transform2D(rotation, GUN_SCALE, 0, Vector2(0,0))
