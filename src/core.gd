class_name Core
extends Room

const GAME_OVER_SCENE := preload("res://scenes/game_over_screen.tscn")
var score_node: Score

func _ready() -> void:
	max_breakaway = 70
	var body_unsafe := get_node("%Body")
	assert(body_unsafe is RigidBody2D, "Somebody's been mucking with the core nodes")
	body = body_unsafe as RigidBody2D
	default_ready()

func _process(delta: float) -> void:
	default_process(delta)
	if breakaway > max_breakaway:
		var tree := get_tree()
		var current_scene := tree.get_current_scene()
		var game_over_node := GAME_OVER_SCENE.instantiate()
		current_scene.get_parent().add_child(game_over_node)
		var score_node_unsafe := current_scene.get_node("%Score")
		assert(score_node_unsafe is Score, "someone's messed with score node in main")
		score_node = score_node_unsafe as Score
		# TODO: make this safe
		game_over_node.set_time(score_node.get_time())
		tree.set_current_scene(game_over_node)
		current_scene.queue_free()
		#game_over_scene.set_time(100) # TODO: Change this to scene timer value and figure out why it doesnt work
		#get_tree().change_scene_to_packed(game_over_scene)
#
#func _physics_process(delta: float) -> void:
	#default_physics_process(delta)
