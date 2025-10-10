@abstract class_name PlayerState extends State

@export var player: Player

func get_context() -> Dictionary[String, Variant]:
	return {
		"speed": player.speed
	}