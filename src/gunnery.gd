class_name Gunnery
extends Room

const POWERED_GUN := preload("res://assets/misc/bow_ready.svg")
const UNPOWERED_GUN := preload("res://assets/misc/bow_charging.svg")
const ARROW := preload("res://scenes/arrow.tscn")
var gun_picture: Sprite2D
const GUN_SCALE := Vector2(0.247, 0.247)
var cur_arrow: Arrow = null
const ARROW_SPEED: float = 500
var arrows: Array[Arrow]
# It's not super important, so it can be really big
const RANGE_SQUARED: float = 2000 * 2000

func _ready() -> void:
	var gun_picture_unsafe := get_node("%GunPicture")
	assert(gun_picture_unsafe is Sprite2D, "Somebody's been mucking with the gunnery nodes")
	gun_picture = gun_picture_unsafe as Sprite2D
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the gunnery nodes")
	body = body_unsafe as RigidBody2D
	var repair_sign_unsafe := get_node("%RepairSign")
	assert(repair_sign_unsafe is Sprite2D, "Somebody's been mucking with the gunnery nodes")
	repair_sign = repair_sign_unsafe as Sprite2D
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)
	var new_arrows: Array[Arrow]
	for arrow in arrows:
		if body.global_position.distance_squared_to(arrow.body.global_position) > RANGE_SQUARED:
			arrow.queue_free()
		else:
			new_arrows.append(arrow)
	arrows = new_arrows
	if powered:
		var new_rotation := body.transform.origin.angle_to_point(target)
		gun_picture.transform = Transform2D(new_rotation, GUN_SCALE, 0, Vector2(0,0))
		cur_arrow.set_trans(new_rotation, body.global_position)

func fire(new_target: Vector2) -> void:
	if cur_arrow != null:
		cur_arrow.fire((new_target-body.global_position).normalized()*ARROW_SPEED, body.global_position)
		arrows.append(cur_arrow)
		cur_arrow = ARROW.instantiate() as Arrow
		add_child(cur_arrow)

func set_powered(new_powered: bool) -> void:
	powered = new_powered
	if (set_powered):
		return
	if powered:
		gun_picture.texture = POWERED_GUN
		if cur_arrow == null:
			cur_arrow = ARROW.instantiate() as Arrow
			add_child(cur_arrow)
	else:
		gun_picture.texture = UNPOWERED_GUN
		if cur_arrow != null:
			cur_arrow.queue_free()
			cur_arrow = null

func _physics_process(delta: float) -> void:
	default_physics_process(delta)

func press_button(_button: Area2D) -> void:
	if state == ROOM_STATE.ATTACHED or state == ROOM_STATE.REPAIRING:
		set_powered(not powered)
