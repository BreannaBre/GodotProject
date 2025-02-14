class_name GameOver
extends Node2D

@export var label: Label
var timer := 0.0

func _ready() -> void:
	label.text = "Time Survived:"

func set_time(value: float) -> void:
	timer = value
	label.text = "Time Survived: " + str(value) + " seconds"

func _on_restart_button_pressed() -> void:
	pass # Replace with function body.
