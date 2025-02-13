class_name Core
extends Room

var game_over_scene := preload("res://scenes/game_over_screen.tscn")

func _ready() -> void:
	max_breakaway = 1
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the core nodes")
	body = body_unsafe as RigidBody2D
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)
	if breakaway > max_breakaway:
		game_over_scene.set_time(100) # TODO: Change this to scene timer value and figure out why it doesnt work
		get_tree().change_scene_to_packed(game_over_scene)
#
#func _physics_process(delta: float) -> void:
	#default_physics_process(delta)
