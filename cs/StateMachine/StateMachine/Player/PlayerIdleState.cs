using Godot;
using static Godot.GD;
using System;

[GlobalClass]
public partial class PlayerIdleState : PlayerState
{
    
    // METHODS.


    protected override void _OnEnterState()
    {
        Print("Enter idle");
    }

    protected override void _OnExitState()
    {
        Print("Exit idle");
    }

    public override void _StateProcess(double delta)
    {}

    public override void _StatePhysicsProcess(double delta)
    {}
}
