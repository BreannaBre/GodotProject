extends Node2D

const gunRoomScene := preload("res://scenes/gun_room.tscn")
var rooms: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rooms = get_node("%RoomsNode")
	add_room(gunRoomScene, Vector2(300,300))
	add_room(gunRoomScene, Vector2(300+181,300))
	add_room(gunRoomScene, Vector2(300+181,300+181))
	add_room(gunRoomScene, Vector2(300,300+181))
	add_room(gunRoomScene, Vector2(300,300-181))

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
	var newRoom:Node2D = room.instantiate()
	newRoom.transform.origin = coords
	rooms.add_child(newRoom)
