extends Node2D

# I have no idea why this number is what it is...
const TUBE_LENGTH: float = 380
var tubes: Array[RID] = []

const GUNNERY_LEFT_SCENE := preload("res://scenes/gunnery_left.tscn")
const GUNNERY_RIGHT_SCENE := preload("res://scenes/gunnery_right.tscn")
const CORE_SCENE := preload("res://scenes/core.tscn")
const THRUSTER_SCENE := preload("res://scenes/thruster.tscn")
const SHIELD_LEFT_SCENE := preload("res://scenes/shield_left.tscn")
const SHIELD_RIGHT_SCENE := preload("res://scenes/shield_right.tscn")
const PENTAGON_SCENE := preload("res://scenes/pentagon.tscn")
var rooms: Array[Room] = []
var core_coords: Vector2

const ANGRY_FACE_SCENE := preload("res://scenes/angry_face.tscn")
var enemies: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	core_coords = get_viewport_rect().size / 2

	var mid := add_room(CORE_SCENE, core_coords)
	var left := add_room(SHIELD_LEFT_SCENE, core_coords + Vector2(-200,0))
	var top_left := add_room(GUNNERY_LEFT_SCENE, core_coords + Vector2(-200,-200))
	var top := add_room(PENTAGON_SCENE, core_coords + Vector2(0,-200))
	var top_right := add_room(GUNNERY_RIGHT_SCENE, core_coords + Vector2(200,-200))
	var right := add_room(SHIELD_RIGHT_SCENE, core_coords + Vector2(200,0))
	var bottom := add_room(THRUSTER_SCENE, core_coords + Vector2(0,200))
	bottom.set_target(core_coords + Vector2(0,180))

	add_tube(mid, left, Vector2(-TUBE_LENGTH,0), Vector2())
	add_tube(mid, right, Vector2(TUBE_LENGTH,0), Vector2())
	add_tube(mid, top, Vector2(0,-TUBE_LENGTH), Vector2())
	add_tube(mid, bottom, Vector2(0,TUBE_LENGTH), Vector2())
	add_tube(mid, top_left, Vector2(-TUBE_LENGTH,-TUBE_LENGTH), Vector2())
	add_tube(mid, top_right, Vector2(TUBE_LENGTH,-TUBE_LENGTH), Vector2())

	for room: Room in rooms:
		room.set_sleep(false)

	#var new_enemy := add_enemy(ANGRY_FACE_SCENE, Vector2(0, 400))
	#new_enemy.set_target(core_coords)
	#new_enemy.set_sleep(false)

func _physics_process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click_event := event as InputEventMouseButton
		for room in rooms:
			if not room is Thruster:
				room.fire(click_event.position)
	elif event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		for room in rooms:
			if not room is Thruster:
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

func add_tube(A: Room, B: Room, A_offset: Vector2 = Vector2(), B_offset: Vector2 = Vector2()) -> RID:
	var joint := PhysicsServer2D.joint_create()
	PhysicsServer2D.joint_make_damped_spring(joint, A.body.global_position + A_offset, B.body.global_position + B_offset, A.body, B.body)
	PhysicsServer2D.damped_spring_joint_set_param(joint, PhysicsServer2D.DAMPED_SPRING_REST_LENGTH, 0)
	PhysicsServer2D.damped_spring_joint_set_param(joint, PhysicsServer2D.DAMPED_SPRING_STIFFNESS, 10)
	tubes.append(joint)
	return joint
