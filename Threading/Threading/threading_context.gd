class_name ThreadingContex extends Node

# VARIABLES

var sum: int = 0

var _threads: Array[Thread] = []
var _mutex: Mutex = Mutex.new()

@export var n: int
@export var multiplicator: int

# ENGINE

func _ready() -> void:

	# Creates the n threads
	for i in n:
		_threads.append(Thread.new())
		_threads[i].start(thread.bind(i))
	
	# Waits for all threads
	for i in n:
		_threads[i].wait_to_finish()
		
	var expected: int = 0
	for i in n:
		expected += (i + 1) * multiplicator
	
	print("Expected %d, got %d" % [expected, sum])
	
# METHODS

func thread(i: int) -> void:
	_mutex.lock()
	
	sum += (i + 1) * multiplicator
	
	_mutex.unlock()
