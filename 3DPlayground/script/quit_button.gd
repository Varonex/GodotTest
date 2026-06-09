extends Button

func _ready() -> void:
	pressed.connect(func(): get_tree().quit(0), CONNECT_ONE_SHOT)