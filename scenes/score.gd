extends Label


# Called when the node enters the scene tree for the first time.
var time = 0
func _ready() -> void:
	text = "Time Survived: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	text = "Time Survived: " + str(int(time))

#TODO: need function to stop time when game ends
