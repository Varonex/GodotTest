class_name PlayerIdleState extends PlayerState

# METHODS

func _enter_state() -> void:
	print("Enter idle")
	
func _exit_state() -> void:
	print("Exit idle")
	
func _state_process(_delta: float) -> void:
	pass
	
func _state_physics_process(_delta: float) -> void:
	pass