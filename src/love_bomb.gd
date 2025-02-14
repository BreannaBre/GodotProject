class_name AngryFace
extends Enemy

var sprite: Sprite2D
const ACCEL := 50
const SPEED := 10000
const TURN := 60
const EXPLODE_FORCE := 1
const DAMAGE_MULT := 0.1

var explode_sound := preload("res://assets/sounds/explode.mp3")
var explode_player: AudioStreamPlayer2D

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the angry face nodes")
	body = body_unsafe as RigidBody2D
	var sprite_unsafe := get_node("%Sprite")
	assert(sprite_unsafe is Sprite2D, "Angry face sprite error")
	sprite = sprite_unsafe as Sprite2D
	explode_player = get_parent().get_node("%ExplodePlayer")
	default_ready()

func _physics_process(_delta: float) -> void:
	# I would comment what this code does, but honestly vector math confuses me.
	# A lot of this was written through guess-and-check lol.
	var speed := body.linear_velocity.length_squared()
	var target_angle := body.linear_velocity.angle_to(target - body.position)
	var heading := body.linear_velocity.normalized()
	var force := Vector2(0,0)

	sprite.flip_h = heading.x < 0

	if speed > SPEED+20:
		force -= heading * ACCEL
	elif speed < SPEED-20:
		force += (target - body.position).normalized() * ACCEL

	# Force applied at a quarter turn from the direction of movement doesn't
	# change speed, only angle.
	if target_angle < -0.2:
		force += heading.rotated(-0.5 * PI) * TURN
	elif target_angle > 0.2:
		force += heading.rotated(0.5 * PI) * TURN

	body.apply_central_force(force)

func _on_body_entered(_other: Node) -> void:
	var ship := get_tree().get_nodes_in_group("rooms")
	if !explode_player.is_playing():
		explode_player.stream = explode_sound
		explode_player.play()
	for room in ship:
		# idk how to assert this safely
		assert(room is Room, "Don't touch the rooms group please!")
		var safe_room := room as Room
		var dist := body.global_position.distance_squared_to(
			safe_room.body.global_position + safe_room.offset_center
		) / 1000
		var dir := body.global_position.direction_to(safe_room.body.global_position)
		var inverse_square := 1000 / maxf(1.0, dist)
		var force := EXPLODE_FORCE * inverse_square
		var damage := DAMAGE_MULT * inverse_square
		safe_room.body.apply_impulse(force * dir)
		safe_room.damage(damage)
	queue_free()
