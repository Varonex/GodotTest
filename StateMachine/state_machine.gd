class_name StateMachine extends Node

signal on_state_changed(new_state: State)

@export var state: State:
	set(value):
		state = value
		on_state_changed.emit(state)

@export var is_active: bool:
	get: return is_active
	set(value):
		is_active = value
		
		set_process(is_active)
		set_physics_process(is_active)

var has_ended: bool:
	get: return state.out_transitions.size() == 0

func _ready() -> void:
	assert(state != null, "Aucune state de départ")
	
	state._on_enter()
	
func _process(delta: float) -> void:
	state._state_process(delta)
	
	var new_state: State = state.transition_to()
	change_state(new_state)
	
func change_state(new_state: State) -> void:
	if new_state != null:
		state.on_exit()
		new_state.on_enter()

		state = new_state

func _physics_process(delta: float) -> void:
	state._state_physics_process(delta)