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

#when game starts this *disappears* and doesn't come back unless we implement it
func _on_start_button_pressed() -> void:
	get_tree().paused = false
	self.queue_free()

#NOTE: I accidently only made startButton the top order of visibility but it created a kind fire title screen
#set title screen to ordering 6 if we want a title
#Also just remove TitleScreen from main if it gets annoying during testing, just link back in and it works
