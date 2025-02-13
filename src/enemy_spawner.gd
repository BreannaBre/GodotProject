extends Node

@export var max_rate := 2.0
@export var delay_mult := 200.0

var accumulator := 0.0
var spawn_counter := 40
var Enemy := preload ("res://scenes/angry_face.tscn")

func _process(delta: float) -> void:
	accumulator += delta
	if (accumulator > 200/spawn_counter + 2):
		spawn_counter += 1
		accumulator = 0
		createEnemy()

func createEnemy():
	var e := Enemy.instantiate()
	var viewport := get_viewport_rect().size
	e.position = Vector2(randf_range(0.0, 200.0), randf_range(0.0, 200.0));
	add_child(e)
