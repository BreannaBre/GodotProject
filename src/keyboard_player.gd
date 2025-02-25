extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

var sprite: Sprite2D
var starting_position := Vector2(584.12, 299.025)

var weld_picker_params := PhysicsPointQueryParameters2D.new()
var button_picker_params := PhysicsPointQueryParameters2D.new()
var current_welded: Room

var jump_sound := preload("res://assets/sounds/jump.mp3")
var jump_player: AudioStreamPlayer2D

func _ready() -> void:
	var sprite_node := get_node("%Fishcat")
	assert(sprite_node is Sprite2D, "Player sprite was not Sprite2D")
	sprite = sprite_node as Sprite2D

	jump_player = get_node("%JumpPlayer")

	# we only want to collide with the room areas
	weld_picker_params.collide_with_areas = true
	weld_picker_params.collide_with_bodies = false
	weld_picker_params.collision_mask = 0b1000
	# we only want to collide with the button areas
	button_picker_params.collide_with_areas = true
	button_picker_params.collide_with_bodies = false
	button_picker_params.collision_mask = 0b0100_0000

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 10

	# Handle jump.
	if Input.is_action_pressed("Player1Jump") and is_on_floor():
		if !jump_player.is_playing():
			jump_player.stream = jump_sound
			jump_player.play()
		velocity.y = JUMP_VELOCITY

	#reset hoizontal velocity
	velocity.x = 0
	#direction based on input
	if Input.is_action_pressed("Player1Left"):
		sprite.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed("Player1Right"):
		sprite.flip_h = false
		velocity.x += 1
	velocity.x = velocity.x*SPEED

	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Player1Weld"):
		#var key_event := event as InputEventKey
		# TODO: Does this have to be gotten every time?
		var space := get_world_2d().direct_space_state
		weld_picker_params.position = global_position
		for result in space.intersect_point(weld_picker_params, 1):
			# I know it's "unsafe", but I think it's pretty safe.
			# Plus I don't want to look up how to make it safe.
			var collider := result["collider"] as Area2D
			var unsafe_welded := collider.get_parent().get_parent()
			assert(unsafe_welded is Room, "Something is up with the room colliders. See style_guide.txt")
			current_welded = unsafe_welded as Room
			current_welded.start_welding(get_rid())
	elif Input.is_action_just_released("Player1Weld"):
		current_welded.stop_welding(get_rid())

	if Input.is_action_just_pressed("Player1Interact"):
		var space := get_world_2d().direct_space_state
		button_picker_params.position = global_position
		for result in space.intersect_point(button_picker_params, 1):
			# I know it's "unsafe", but I think it's pretty safe.
			# Plus I don't want to look up how to make it safe.
			var collider := result["collider"] as Area2D
			var unsafe_pressed := collider.get_parent().get_parent()
			assert(unsafe_pressed is Room, "Something is up with the button colliders. See style_guide.txt")
			var pressed_room := unsafe_pressed as Room
			if pressed_room.state == Room.ROOM_STATE.ATTACHED or pressed_room.state == Room.ROOM_STATE.REPAIRING:
				var main := get_parent()
				main.power_room(pressed_room)

	var current_screen_size_y := get_viewport_rect().size.y
	if position.y > current_screen_size_y*3:
		reset_position()

func reset_position() -> void:
	velocity = Vector2(0,0)
	position = starting_position
