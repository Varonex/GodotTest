@tool
extends Node

@warning_ignore("unused_private_class_variable")
@export_tool_button("Run dictionary test") var _dict_test: Callable = test_dict

@warning_ignore("unused_private_class_variable")
@export_tool_button("Run array test") var _array_test: Callable = test_arr

@warning_ignore("unused_private_class_variable")
@export_tool_button("Run 2nd dictionary test") var _dict_test2: Callable = test_dict2

@warning_ignore("unused_private_class_variable")
@export_tool_button("Run 2nd array test") var _array_test2: Callable = test_arr2

func test_dict() -> void:
	var a: Dictionary = {}
	var _b: Dictionary[String, int] = a
	
func test_arr() -> void:
	var a: Array = []
	var _b: Array[String] = a

func test_dict2() -> void:
	var a: Dictionary[String, Variant] = {}
	var _b: Dictionary[String, int] = a

func test_arr2() -> void:
	var a: Array[Variant] = []
	var _b: Array[String ] = a
