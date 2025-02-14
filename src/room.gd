class_name Room
extends Node2D

enum ROOM_STATE {ATTACHED, DETACHED, REATTACHING, REPAIRING}

const REATTACH_TIME: float = 6
var target := Vector2(0,0)
var state := ROOM_STATE.DETACHED
var body: RigidBody2D
var next_shake: int = 0
var breakaway: float = 0
var max_breakaway := 70.0
var tube: RID
var welders: Array[RID]
var host: RigidBody2D
var reattach_work: float = 0
var repair_sign: Sprite2D
var powered := false
var breakaway_visual := Color(1,1,1,1)
@export var offset_center := Vector2(0, 0)

var pop_sound := preload("res://assets/sounds/pop.mp3")
var pop_player: AudioStreamPlayer2D

# This sets up defaults for the RigidBody2D, so make sure body has been
# properly assigned!
func default_ready() -> void:
	add_to_group("rooms")
	body.lock_rotation = true
	body.linear_damp = 1
	body.collision_layer = 0b1000
	body.collision_mask  = 0b1100
	tube = PhysicsServer2D.joint_create()
	pop_player = get_parent().get_node("%PopPlayer")

func default_process(delta: float) -> void:
	if state == ROOM_STATE.REATTACHING:
		reattach_work -= delta * welders.size()
		if reattach_work <= 0:
			breakaway = 0
			set_state(ROOM_STATE.REPAIRING)
	elif state == ROOM_STATE.REPAIRING:
		breakaway -= delta * welders.size() * 20
		if breakaway < 0:
			breakaway = 0
# Currently color darkens over time, may make modular if that looks better
	var rgb_values := 1-(breakaway/max_breakaway)
	if rgb_values < 0.15:
		rgb_values = 0.15
	breakaway_visual = Color(rgb_values, rgb_values, rgb_values, 1)
	modulate = breakaway_visual

func default_physics_process(_delta: float) -> void:
	if state == ROOM_STATE.ATTACHED:
		shake()
		if breakaway > max_breakaway:
			set_state(ROOM_STATE.DETACHED)
			pop_off(true)

func set_target(new_target: Vector2) -> void:
	target = new_target

func set_state(new_state: ROOM_STATE) -> void:
	var main := get_parent()
	state = new_state
	if state == ROOM_STATE.DETACHED:
		body.gravity_scale = 1
		main.remove_room(self)
		if repair_sign != null:
			repair_sign.hide()
	elif state == ROOM_STATE.ATTACHED:
		body.gravity_scale = 0
		if repair_sign != null:
			repair_sign.hide()
	elif state == ROOM_STATE.REATTACHING:
		body.gravity_scale = 0
		main.remove_room(self)
		if repair_sign != null:
			repair_sign.show()
	elif state == ROOM_STATE.REPAIRING:
		body.gravity_scale = 0
		if repair_sign != null:
			repair_sign.hide()

func set_pos(new_pos: Vector2) -> void:
	body.transform.origin = new_pos

func set_host(new_host: RigidBody2D) -> void:
	host = new_host

func set_powered(_new_powered: bool) -> void:
	pass

func pop_off(violent: bool) -> void:
	if !pop_player.is_playing():
		pop_player.stream = pop_sound
		pop_player.play()
	reattach_work = REATTACH_TIME
	PhysicsServer2D.joint_clear(tube)
	if violent:
		var new_vel := body.global_position - host.global_position
		new_vel = new_vel.normalized() * 200
		new_vel += Vector2(0, -30)
		body.linear_velocity = new_vel

func pop_on() -> void:
	PhysicsServer2D.joint_make_damped_spring(tube, body.global_position, body.global_position, host, body)
	PhysicsServer2D.damped_spring_joint_set_param(tube, PhysicsServer2D.DAMPED_SPRING_REST_LENGTH, 0)
	PhysicsServer2D.damped_spring_joint_set_param(tube, PhysicsServer2D.DAMPED_SPRING_STIFFNESS, 10)

func fire(_new_target: Vector2) -> void:
	pass

func shake() -> void:
	var cur := Time.get_ticks_msec()
	if cur > next_shake:
		next_shake = cur + randf_range(10000/(breakaway+1), 50000/(breakaway+1)) as int
		breakaway += 1
		var impulse := Vector2(randf_range(-breakaway, breakaway), randf_range(-breakaway, breakaway))
		body.apply_impulse(impulse)

func start_welding(weldee: RID) -> void:
	welders.append(weldee)
	if state == ROOM_STATE.ATTACHED:
		set_state(ROOM_STATE.REPAIRING)
	elif state == ROOM_STATE.DETACHED:
		set_state(ROOM_STATE.REATTACHING)
		pop_on()

func stop_welding(weldee: RID) -> void:
	welders.erase(weldee)
	if welders.size() == 0:
		if state == ROOM_STATE.REPAIRING:
			set_state(ROOM_STATE.ATTACHED)
		elif state == ROOM_STATE.REATTACHING:
			set_state(ROOM_STATE.DETACHED)
			reattach_work = REATTACH_TIME
			pop_off(false)

func damage(amount: float) -> void:
	breakaway += amount
