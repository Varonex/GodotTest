extends Label

func _process(_delta: float) -> void:
	text = "FPS : %.2f" % Engine.get_frames_per_second()