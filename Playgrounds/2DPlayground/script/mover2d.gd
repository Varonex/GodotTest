extends Node2D

# VARIABLES

@export var target: Node2D
@export var min_offset: Vector2
@export var max_offset: Vector2
@export var duration: float = 1

@export var enabled: bool = true:
	set(v):
		enabled = v
		
		if not v:
			_tween.kill()
			_tween = null
		
		else:
			_tween = create_tween()
			_tween.set_ease(Tween.EASE_IN_OUT) \
					.set_trans(Tween.TRANS_LINEAR) \
					.set_loops()
			
			_tween.tween_property(target, ^"global_position", _init_global_position + max_offset, duration)
			_tween.tween_property(target, ^"global_position", _init_global_position + min_offset, duration)					

var _tween: Tween
var _init_global_position: Vector2

# ENGINE

func _ready() -> void:
	_init_global_position = global_position
	global_position = global_position + max_offset
	enabled = enabled