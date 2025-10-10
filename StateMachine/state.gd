@abstract class_name State extends Node

signal enter_state
signal exit_state

@export var out_transitions: Array[StateTransition] = []

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func on_enter() -> void:
	_on_enter()
	enter_state.emit()

@abstract func _on_enter() -> void
	
func on_exit() -> void:
	_on_exit()
	exit_state.emit()

@abstract func _on_exit() -> void
	
@abstract func _state_process(delta: float) -> void
	
@abstract func _state_physics_process(delta: float) -> void

@abstract func get_context() -> Dictionary[String, Variant]

func transition_to() -> State:
	for out_transition: StateTransition in out_transitions:
		if out_transition.can_transition(get_context()):
			return get_node( out_transition.target_state ) as State
			
	return null
	