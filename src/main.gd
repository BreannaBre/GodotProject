extends Node2D

const GUNNERY_LEFT_SCENE := preload("res://scenes/gunnery_left.tscn")
const GUNNERY_RIGHT_SCENE := preload("res://scenes/gunnery_right.tscn")
const CORE_SCENE := preload("res://scenes/core.tscn")
const THRUSTER_SCENE := preload("res://scenes/thruster.tscn")
const SHIELD_LEFT_SCENE := preload("res://scenes/shield_left.tscn")
const SHIELD_RIGHT_SCENE := preload("res://scenes/shield_right.tscn")
const PENTAGON_SCENE := preload("res://scenes/pentagon.tscn")
var rooms: Array[Room] = []
var core_coords: Vector2
var core_object: Core

var mouse_joint := PhysicsServer2D.joint_create()
var mouse_body: StaticBody2D
var mouse_dragging := false
var mouse_params := PhysicsPointQueryParameters2D.new()

const LOVE_BOMB_SCENE := preload("res://scenes/love_bomb.tscn")
const HEART_BURN_SCENE := preload("res://scenes/heart_burn.tscn")
var enemies: Array[Enemy] = []
var windowSize := DisplayServer.screen_get_size()
const SPAWN_DELTA := 0.0625
const INIT_DELAY := 1.0
const MIN_DELAY := 1.0
var spawn_delay: float
var spawn_tick_acc: float

var previous_room: Room
var current_room: Room

func _ready() -> void:
	spawn_delay = INIT_DELAY
	spawn_tick_acc=0

	core_coords = get_viewport_rect().size / 2
	var body_unsafe := get_node("%MouseBody")
	assert(body_unsafe is StaticBody2D, "Somebody's been mucking with the mouse nodes")
	mouse_body = body_unsafe as StaticBody2D
	# we only want to collide with the room areas
	mouse_params.collide_with_areas = true
	mouse_params.collide_with_bodies = false
	mouse_params.collision_mask = 0b1000

	core_object = add_room(CORE_SCENE, core_coords)
	add_room(SHIELD_LEFT_SCENE, core_coords + Vector2(-181,0))
	add_room(GUNNERY_LEFT_SCENE, core_coords + Vector2(-181,-181))
	add_room(PENTAGON_SCENE, core_coords + Vector2(0,-181))
	add_room(GUNNERY_RIGHT_SCENE, core_coords + Vector2(181,-181))
	add_room(SHIELD_RIGHT_SCENE, core_coords + Vector2(181,0))
	var thruster := add_room(THRUSTER_SCENE, core_coords + Vector2(0,181))
	thruster.set_target(core_coords + Vector2(0,181))

	for room in rooms:
		if room is Core:
			continue
		room.set_host(core_object.body)

	for room in rooms:
		room.set_state(room.ROOM_STATE.ATTACHED)

	# I hate joints. I hate joints. I hate joints. I hate joints. I hate joints.
	await get_tree().physics_frame
	for room in rooms:
		if room is Core:
			continue
		room.pop_on()

func _process(delta: float) -> void:
	var new_enemies: Array[Enemy]
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.set_target(core_object.body.global_position)
			new_enemies.append(enemy)
	enemies = new_enemies
	spawn_tick(delta)

func _physics_process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click_event := event as InputEventMouseButton
		if click_event.button_index == MOUSE_BUTTON_LEFT:
			if click_event.pressed == true:
				for room in rooms:
					if not room is Thruster:
						room.fire(click_event.position)
		elif click_event.button_index == MOUSE_BUTTON_RIGHT:
			if click_event.pressed == true and mouse_dragging == false:
				# TODO: Does this have to be gotten every time?
				var space := get_world_2d().direct_space_state
				mouse_params.position = click_event.position
				mouse_body.position = click_event.position
				for result in space.intersect_point(mouse_params, 1):
					# I know it's "unsafe", but I think it's pretty safe.
					# Plus I don't want to look up how to make it safe.
					var collider := result["collider"] as Area2D
					var unsafe_body := collider.get_parent()
					assert(unsafe_body is RigidBody2D, "Something is up with the room colliders. See style_guide.txt")
					var body := unsafe_body as RigidBody2D
					PhysicsServer2D.joint_make_damped_spring(mouse_joint, mouse_body.global_position, mouse_body.global_position, mouse_body, body)
					PhysicsServer2D.damped_spring_joint_set_param(mouse_joint, PhysicsServer2D.DAMPED_SPRING_REST_LENGTH, 0)
					PhysicsServer2D.damped_spring_joint_set_param(mouse_joint, PhysicsServer2D.DAMPED_SPRING_STIFFNESS, 30)
					mouse_dragging = true
			elif click_event.pressed == false and mouse_dragging == true:
				PhysicsServer2D.joint_clear(mouse_joint)
				mouse_dragging = false
	elif event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		mouse_body.position = motion_event.position
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

func spawn_tick(delta: float) -> void:
	spawn_tick_acc += delta
	if (spawn_tick_acc > spawn_delay):
		spawn_tick_acc = 0
		spawn_delay = maxf(spawn_delay - SPAWN_DELTA, MIN_DELAY)
		var location := windowSize.y/2 * Vector2.from_angle(randf_range(-PI, 0))
		location.x = windowSize.x/2 * signf(location.x)
		var new_enemy := add_enemy(
			[HEART_BURN_SCENE, LOVE_BOMB_SCENE].pick_random() as PackedScene,
			location + core_coords
		)
		new_enemy.set_target(core_coords)

func add_enemy(enemy: PackedScene, coords: Vector2) -> Enemy:
	var new_node := enemy.instantiate()
	assert(new_node is Enemy, "woah woah woah buddy, only add *enemies* please")
	var new_enemy := new_node as Enemy
	add_child(new_enemy)
	new_enemy.set_pos(coords)
	enemies.append(new_enemy)
	return new_enemy

func remove_room(room: Room) -> void:
	if previous_room == room:
		previous_room = null
	if current_room == room:
		current_room = null
	room.set_powered(false)

func power_room(room: Room) -> void:
	if (room.powered): return
	if current_room != null && previous_room != null:
		previous_room.set_powered(false)
	if current_room != null:
		previous_room = current_room
	current_room = room
	room.set_powered(true)
