extends Node

@export var wait_time: float = 1

func _ready() -> void:
	await get_tree().create_timer(wait_time).timeout
	
	if get_parent():
		get_parent().queue_free()
