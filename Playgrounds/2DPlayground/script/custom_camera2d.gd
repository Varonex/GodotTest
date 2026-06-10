extends Camera2D

# VARIABLES

## The movement speed of the camera.
@export var linear_speed: float = 1600

# ENGINE

func _process(delta: float) -> void:
	# Plan de contrôle.
	var plane: Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward")
	
	# Shift.
	var linear_shift: Vector2 = plane * linear_speed * delta
	
	# On translate.
	position = position + linear_shift