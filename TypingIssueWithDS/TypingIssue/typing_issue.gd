@tool
extends Node

@export_tool_button("Run dictionary test") var _dict_test: Callable = test_dict
@export_tool_button("Run array test") var _array_test: Callable = test_arr

func test_dict() -> void:
	var a: Dictionary = {}
	var _b: Dictionary[String, int] = a
	
func test_arr() -> void:
	var a: Array = []
	var _b: Array[String] = a