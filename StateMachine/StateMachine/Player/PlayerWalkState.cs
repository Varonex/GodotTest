using Godot;
using static Godot.GD;
using System;

[GlobalClass]
public partial class PlayerWalkState : PlayerState
{
    
    // METHODS.


    protected override void _OnEnterState()
    {
        Print("Enter walk");
    }

    protected override void _OnExitState()
    {
        Print("Exit walk");
    }

    public override void _StateProcess(double delta)
    {}

    public override void _StatePhysicsProcess(double delta)
    {}
}
