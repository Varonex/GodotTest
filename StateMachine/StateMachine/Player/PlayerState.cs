using Godot;
using System;
using System.Collections.Generic;

[GlobalClass]
public abstract partial class PlayerState : State
{
    
    // VARIABLES.


    [Export] private Player _player;


    // METHODS.


    public override Dictionary<string, object> GetContext()
    {
        return new Dictionary<string, object>()
        {
            ["Speed"] = _player.Speed,
        };
    }
}
