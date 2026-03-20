class_name StateMachine extends Node

# VARIABLES

## Start state.
@export var _state: State

## Describes whether or not the current state machine is active.
@export var is_active: bool:
	get: return is_active
	set(v):
		is_active = v
		set_process(v)
		set_physics_process(v)

var has_ended: bool:
	get: return _state.transition_count == 0
	set(v): pass

# SIGNALS

## Is emitted when the state machine transitioned to a new state.
signal state_changed(new_state: State)

# ENGINE

func _ready() -> void:
	# Hot reload update.
	is_active = is_active

	_state.enter_state()

func _process(delta: float) -> void:
	_state._state_process(delta)
	
	# Change the state if needed.
	change_state(_state.transition_to())

func _physics_process(delta: float) -> void:
	_state._state_physics_process(delta)

# METHODS

##Changes the current state.
func change_state(new_state: State) -> void:
	if new_state != null:
		_state.exit_state()
		new_state.enter_state()
		
		_state = new_state
		
		state_changed.emit(new_state)
