extends Node2D

var blue_planet: AnimatedSprite2D
var orange_planet: AnimatedSprite2D

func _ready() -> void:
	var blue_planet_unsafe := get_node("BluePlanetAnimation")
	assert(blue_planet_unsafe is AnimatedSprite2D, "Somebody's been mucking with the titlescreen nodes")
	blue_planet = blue_planet_unsafe as AnimatedSprite2D
	blue_planet.play()
	var orange_planet_unsafe := get_node("OrangePlanetAnimation")
	assert(orange_planet_unsafe is AnimatedSprite2D, "Somebody's been mucking with the titlescreen nodes")
	orange_planet = orange_planet_unsafe as AnimatedSprite2D
	orange_planet.play()
