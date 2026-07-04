extends RigidBody3D

var _timer: Timer = Timer.new()
var _cached_transform: Transform3D
var _n_spam: int = 50
var _n_counter: int

func _ready() -> void:
	_timer.name = "CountdownTimer"
	_timer.wait_time = 1
	_timer.autostart = true
	_timer.timeout.connect(_on_timeout)
	
	add_child.call_deferred(_timer)
	
	await get_tree().process_frame
	_cached_transform = global_transform

func _process(_delta: float) -> void:
	if _n_counter > _n_spam:
		_n_counter = 0
		print(get_gravity())
	else:
		_n_counter += 1

func _on_timeout() -> void:
	global_transform = _cached_transform
