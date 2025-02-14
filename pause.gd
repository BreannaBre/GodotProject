extends Node2D

var is_paused := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		print("ping")
		if not is_paused:
			get_tree().paused = true
			is_paused = true
			show()
		else:
			get_tree().paused = false
			is_paused = false
			hide()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	is_paused = false
	hide()
