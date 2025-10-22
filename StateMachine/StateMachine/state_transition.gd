@abstract class_name StateTransition extends Resource

@export var target_state: NodePath

@abstract func can_transition(context: Dictionary[String, Variant]) -> bool