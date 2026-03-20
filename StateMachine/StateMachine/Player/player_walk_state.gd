class_name PlayerWalkState extends PlayerState

# METHODS

func _enter_state() -> void:
	print("Enter walk")
	
func _exit_state() -> void:
	print("Exit walk")
	
func _state_process(_delta: float) -> void:
	pass
	
func _state_physics_process(_delta: float) -> void:
	pass
