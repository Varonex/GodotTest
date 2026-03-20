class_name WorkerThreadContex extends Node

# VARIABLES

var sum: int = 0

var _mutex: Mutex = Mutex.new()

@export var n: int
@export var multiplicator: int

# ENGINE

func _ready() -> void:

	var group_id: int = WorkerThreadPool.add_group_task(thread, n)
	WorkerThreadPool.wait_for_group_task_completion(group_id)
	
	var expected: int = 0
	for i in n:
		expected += (i + 1) * multiplicator
	
	print("Expected %d, got %d" % [expected, sum])
	
# METHODS

func thread(i: int) -> void:
	_mutex.lock()
	
	sum += (i + 1) * multiplicator
	
	_mutex.unlock()