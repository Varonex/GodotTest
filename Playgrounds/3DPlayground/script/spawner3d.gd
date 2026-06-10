## Spawns the desired item at a certain interval.
class_name Spawner3D extends Marker3D

# VARIABLES

## Parent container that should receive each and every copy. 
@export var container: Node3D

## Scene to instantiate.
@export var blueprint: PackedScene

## Wait time between spawns.
@export var wait_time: float = 1:
	set(v):
		wait_time = v
		_timer.wait_time = v

## Wait time before destroying the spawned instance. 0 means it does not get killed.
@export var kill_time: float = 0

## Spawn range from which an object might spawn.
@export var spawn_range: Vector3

## States whether the spawner is enabled or not.
@export var enabled: bool = true:
	set(v):
		enabled = v
		
		if not _timer.is_node_ready(): return
		
		if v:
			_timer.start(wait_time)
		else:
			_timer.stop()

## Timer node used internally.
var _timer: Timer = Timer.new()

# ENGINE

func _ready() -> void:
	_timer.name = "InternalTimer"
	_timer.wait_time = wait_time
	_timer.timeout.connect(_on_timer_timeout)
	
	add_child(_timer)
	
	if enabled:
		_timer.start(wait_time)

# CALLBACKS

## Callback designed to respond to the timer whenever it is required to 
func _on_timer_timeout() -> void:
	var res: Node3D = blueprint.instantiate()
	container.add_child(res)
	
	var pos: Vector3 = global_position + Vector3(
			(randf() * 2 - 1) * spawn_range.x,
			(randf() * 2 - 1) * spawn_range.y,
			(randf() * 2 - 1) * spawn_range.z
	)
	
	res.global_position = pos
	
	if kill_time > 0:
		get_tree().create_timer(kill_time).timeout.connect(res.queue_free)