extends Node

func _ready() -> void:
	prints("Named:", _my_callback.get_object())
	prints("Lambda:", (func(): pass).get_object())

func _my_callback() -> void:
	pass
