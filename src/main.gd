extends Node2D

const GUN_ROOM_SCENE := preload("res://scenes/gun_room.tscn")
var rooms: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rooms = get_node("%RoomsNode")
	add_room(GUN_ROOM_SCENE, Vector2(300,300))
	add_room(GUN_ROOM_SCENE, Vector2(300+181,300))
	add_room(GUN_ROOM_SCENE, Vector2(300+181,300+181))
	add_room(GUN_ROOM_SCENE, Vector2(300,300+181))
	add_room(GUN_ROOM_SCENE, Vector2(300,300-181))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		for room in rooms.get_children():
			room.fire(room.transform.origin.angle_to_point(event.position))
	elif event is InputEventMouseMotion:
		for room in rooms.get_children():
			room.train(room.transform.origin.angle_to_point(event.position))

func add_room(room: PackedScene, coords: Vector2) -> void:
	var new_room:Node2D = room.instantiate()
	new_room.transform.origin = coords
	rooms.add_child(new_room)
