extends ParallaxLayer

@export var speed: float = 10

func _process(delta: float) -> void:
	self.motion_offset.x += speed * delta
