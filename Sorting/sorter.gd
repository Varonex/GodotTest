@abstract class_name Sorter extends Node

@export var enabled: bool = true
@export var size: int = 5

func _ready() -> void:
	if enabled:
		print("[%s]: %d iterations" % [name, sort()])

func sort() -> int:
	var iter: int = 0
	var arr: Array[int] = _init_rand_array(size)
	
	while not is_sorted(arr):
		_sort(arr)
		iter += 1
	
	return iter

func is_sorted(input: Array[int]) -> bool:
	for i in input.size() - 1:
		if input[i] > input[i + 1]:
			return false

	return true

func _init_rand_array(n: int) -> Array[int]:
	var res: Array[int] = []
	res.resize(n)
	
	for i: int in n:
		res[i] = i
	
	res.shuffle()
	return res

@abstract func _sort(input: Array[int]) -> void
