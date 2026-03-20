@abstract class_name StateTransition extends Resource

# VARIABLES

## Target state to go.
@export var target_state: NodePath

# METHODS

## Determines whether or not the current state can transition using this transition.
@abstract func can_transition(context: Dictionary[String, Variant]) -> bool