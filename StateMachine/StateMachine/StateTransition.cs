using Godot;
using System;
using System.Collections.Generic;

[GlobalClass]
public abstract partial class StateTransition : Resource
{
    
    // VARIABLES.


    // Target state to go to.
    [Export] public NodePath TargetState;
    
    
    // METHODS.

    
    // Determines whether or not the current state can transition.
    public abstract bool CanTransition(Dictionary<String, object> context);
}
