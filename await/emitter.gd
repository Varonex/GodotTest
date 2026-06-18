extends Node

@export var timer: Timer

signal test()
signal test1(a: int)
signal test2(a: int, b: int)

func _ready() -> void:
	assert(timer != null)
	
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	test.emit()
	test1.emit(randi())
	test2.emit(randi(), randi())
	
