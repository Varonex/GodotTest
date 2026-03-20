class_name SpeedTransition extends StateTransition

# VARIABLES

## Speed threshold.
@export var _threshold: float

## Describes whether the transition must be lower than or greater than.
@export var _above: bool = true

# METHODS

func can_transition(context: Dictionary[String, Variant]) -> bool:
	var above: bool = (context.speed as float) >= _threshold
	
	if _above:
		return above
		
	return not above