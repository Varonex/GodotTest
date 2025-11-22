using Godot;
using System;
using System.Collections.Generic;

[GlobalClass]
public partial class SpeedTransition : StateTransition
{
    
    // VARIABLES.


    // Speed threshold.
    [Export] private double _threshold;
    
    // Revert if above.
    [Export] private bool _above = true;
    
    
    // METHODS.


    public override bool CanTransition(Dictionary<string, object> context)
    {
        if (_above)
            return context["Speed"] as double? >= _threshold;
        
        return context["Speed"] as double? < _threshold;
    }
}
