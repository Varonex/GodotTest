class_name PlayerWalkState extends PlayerState

func _on_enter() -> void:
	print("Enter walk")
	
func _on_exit() -> void:
	print("Exit walk")
	
func _state_process(delta: float) -> void:
	pass
	
func _state_physics_process(delta: float) -> void:
	pass