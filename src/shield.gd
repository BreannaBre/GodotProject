class_name Shield
extends Room

@export var force: float = 4
const DIST: float = 230
const POWERED_BUTTON := preload("res://assets/misc/shield_ready.svg")
const UNPOWERED_BUTTON := preload("res://assets/misc/shield_charging.svg")
var button_sprite: Sprite2D

var shield_on_sound := preload("res://assets/sounds/shield_on.mp3")
var shield_off_sound := preload("res://assets/sounds/shield_off.mp3")
@export var shield_player: AudioStreamPlayer2D

func _ready() -> void:
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the shield nodes")
	body = body_unsafe as RigidBody2D
	var button_sprite_unsafe := get_node("%ButtonSprite")
	assert(button_sprite_unsafe is Sprite2D, "Somebody's been mucking with the shield nodes")
	button_sprite = button_sprite_unsafe as Sprite2D
	var repair_sign_unsafe := get_node("%RepairSign")
	assert(repair_sign_unsafe is Sprite2D, "Somebody's been mucking with the shield nodes")
	repair_sign = repair_sign_unsafe as Sprite2D
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)

func _physics_process(delta: float) -> void:
	default_physics_process(delta)

	if not powered:
		return

	var enemies := get_tree().get_nodes_in_group("enemies")
	for unsafe_enemy in enemies:
		assert(unsafe_enemy is Enemy, "Don't touch the enemies group please!")
		var enemy := unsafe_enemy as Enemy
		var dist := absf(enemy.body.global_position.x - body.global_position.x)
		if dist > DIST:
			continue
		var force_vec := Vector2((DIST-dist)*force, 0)
		enemy.body.apply_central_force(force_vec)

func set_powered(new_powered: bool) -> void:
	powered = new_powered
	if powered:
		button_sprite.texture = POWERED_BUTTON
		if !shield_player.is_playing():
			shield_player.stream = shield_on_sound
			shield_player.play()
	else:
		button_sprite.texture = UNPOWERED_BUTTON
		if !shield_player.is_playing():
			shield_player.stream = shield_off_sound
			shield_player.play()
