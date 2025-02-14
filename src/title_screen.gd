extends Node2D

var blue_planet: AnimatedSprite2D
var orange_planet: AnimatedSprite2D
var how_to_play_page: Control
const PAUSE_SCREEN := preload("res://scenes/pause.tscn")

func _ready() -> void:
	var blue_planet_unsafe := get_node("Background/BluePlanetAnimation")
	assert(blue_planet_unsafe is AnimatedSprite2D, "Somebody's been mucking with the titlescreen nodes")
	blue_planet = blue_planet_unsafe as AnimatedSprite2D
	blue_planet.play()
	var orange_planet_unsafe := get_node("Background/OrangePlanetAnimation")
	assert(orange_planet_unsafe is AnimatedSprite2D, "Somebody's been mucking with the titlescreen nodes")
	orange_planet = orange_planet_unsafe as AnimatedSprite2D
	orange_planet.play()
	var how_to_play_unsafe := get_node("%HowToPlayPage")
	assert(how_to_play_unsafe is Control, "Somebody's been mucking with the titlescreen nodes")
	how_to_play_page = how_to_play_unsafe as Control
	#game doesn't start/process until start button is pressed
	how_to_play_page.hide()
	get_tree().paused = true

func _on_start_button_pressed() -> void:
	get_tree().paused = false
	get_parent().add_child(PAUSE_SCREEN.instantiate())
	self.queue_free()

func _on_how_to_play_button_pressed() -> void:
	how_to_play_page.show()

func _on_close_button_pressed() -> void:
	how_to_play_page.hide()
