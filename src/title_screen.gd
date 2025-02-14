extends Node2D

var blue_planet: AnimatedSprite2D
var orange_planet: AnimatedSprite2D

func _ready() -> void:
	var blue_planet_unsafe := get_node("Background/BluePlanetAnimation")
	assert(blue_planet_unsafe is AnimatedSprite2D, "Somebody's been mucking with the titlescreen nodes")
	blue_planet = blue_planet_unsafe as AnimatedSprite2D
	blue_planet.play()
	var orange_planet_unsafe := get_node("Background/OrangePlanetAnimation")
	assert(orange_planet_unsafe is AnimatedSprite2D, "Somebody's been mucking with the titlescreen nodes")
	orange_planet = orange_planet_unsafe as AnimatedSprite2D
	orange_planet.play()
	#game doesn't start/process until start button is pressed
	get_tree().paused = true
	Timer

#when game starts this *disappears* and doesn't come back unless we implement it
func _on_start_button_pressed() -> void:
	get_tree().paused = false
	self.queue_free()

func _on_how_to_play_button_pressed() -> void:
	pass
