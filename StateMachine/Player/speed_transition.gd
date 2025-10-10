class_name SpeedTransition extends StateTransition

@export var threshold: float
@export var above: bool = true

func can_transition(context: Dictionary[String, Variant]) -> bool:
	if above:
		return context["speed"] >= threshold
		
	return context["speed"] <= threshold
	
