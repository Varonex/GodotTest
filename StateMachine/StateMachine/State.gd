@abstract class_name State extends Node

# VARIABLES

## Transitions that can be used to go out of the current state.
@export var _out_transitions: Array[StateTransition] = []

## Transition count.
var transition_count: int:
	get: return _out_transitions.size()
	set(v): pass

# SIGNALS

## Enters the state.
signal state_entered()

## Exits the state.
signal state_exit()

# ENGINE

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

# METHODS

# Method state definition.

## When we enter a state.
func enter_state() -> void:
	_enter_state()
	state_entered.emit()

## Hook method when we enter a state.
@abstract func _enter_state() -> void

## When we exit the state.
func exit_state() -> void:
	_exit_state()
	state_exit.emit()

## Hook method when we exit a state.
@abstract func _exit_state() -> void

# Process callbacks.

## Process on the current state.
@abstract func _state_process(delta: float) -> void

## Process the current physics state.
@abstract func _state_physics_process(delta: float) -> void

# Transitioning.

## Fetches the context.
@abstract func get_context() -> Dictionary[String, Variant]

## Computes the first transition that needs to be reached to.
func transition_to() -> State:
	# Goes over all the transitions.
	for out_transition: StateTransition in _out_transitions:
	
		# If we can transition to the transition using the context, we return the associated state.
		if out_transition.can_transition(get_context()):
			return get_node(out_transition.target_state) as State
	
	return null