extends Node2D

const KERNEL_SCENE := preload("res://scenes/kernel.tscn")
const GUNNERY_SCENE := preload("res://scenes/gunnery.tscn")
var rooms: Array[Room] = []
const ANGRY_FACE_SCENE := preload("res://scenes/angry_face.tscn")
var enemies: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_room(KERNEL_SCENE, Vector2(300,300)).set_sleep(false)
	add_room(GUNNERY_SCENE, Vector2(300-181,300-181)).set_sleep(false)
	add_room(GUNNERY_SCENE, Vector2(300,300-181)).set_sleep(false)
	add_room(GUNNERY_SCENE, Vector2(300+181,300)).set_sleep(false)
	add_room(GUNNERY_SCENE, Vector2(300,300+181)).set_sleep(false)
	add_room(GUNNERY_SCENE, Vector2(300-181,300+181)).set_sleep(false)
	#var new_enemy := add_enemy(ANGRY_FACE_SCENE, Vector2(800, 400))
	#new_enemy.set_target(Vector2(300,300))
	#new_enemy.set_sleep(false)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click_event := event as InputEventMouseButton
		for room in rooms:
			room.fire(click_event.position)
	elif event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		for room in rooms:
			room.set_target(motion_event.position)

func add_room(room: PackedScene, coords: Vector2) -> Room:
	var new_node := room.instantiate()
	assert(new_node is Room, "woah woah woah buddy, only add *rooms* please")
	var new_room := new_node as Room
	add_child(new_room)
	new_room.set_pos(coords)
	rooms.append(new_room)
	return new_room

func add_enemy(enemy: PackedScene, coords: Vector2) -> Enemy:
	var new_node := enemy.instantiate()
	assert(new_node is Enemy, "woah woah woah buddy, only add *enemies* please")
	var new_enemy := new_node as Enemy
	add_child(new_enemy)
	new_enemy.set_pos(coords)
	enemies.append(new_enemy)
	return new_enemy
	
