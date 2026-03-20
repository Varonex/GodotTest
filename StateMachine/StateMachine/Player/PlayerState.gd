@abstract class_name PlayerState extends State

# VARIABLES

@export var _player: StateMachinePlayer

# METHODS

func get_context() -> Dictionary[String, Variant]:
	return {
		"speed": _player.speed
	}