class_name GameOver
extends Node2D

@export var label: Label
var timer := 0.0

var end_sound := preload("res://assets/sounds/womp.mp3")
@export var end_player: AudioStreamPlayer2D

func _ready() -> void:
	label.text = "Time Survived:"
	if !end_player.is_playing():
		end_player.stream = end_sound
		end_player.play()

func set_time(value: float) -> void:
	timer = value
	label.text = "Time Survived: " + str(value) + " seconds"
