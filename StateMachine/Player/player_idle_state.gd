class_name PlayerIdleState extends PlayerState

func _on_enter() -> void:
	print("Enter idle")

func _on_exit() -> void:
	print("Exit idle")
	
func _state_process(delta: float) -> void:
	pass
	
func _state_physics_process(delta: float) -> void:
	pass