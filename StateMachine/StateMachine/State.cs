using Godot;
using System;
using System.Collections.Generic;

[GlobalClass]
public abstract partial class State : Node
{
    
    // FIELDS.

    
    // Transitions that can be used to go out of the current state.
    [Export] private StateTransition[] _outTransitions = {};
    
    // Transition count.
    public int TransitionCount
    {
        get => _outTransitions.Length;
        private set {}
    }
    
    
    // SIGNALS.
    
    
    // Enters the state.
    [Signal] public delegate void EnterStateEventHandler();
    
    // Exits the state.
    [Signal] public delegate void ExitStateEventHandler();
    
    
    // ENGINE.


    public override void _Ready()
    {
        SetProcess(false);
        SetPhysicsProcess(false);
    }
    
    
    // METHODS.
    
    
    // Method state definition.

    // Method called when we enter the state.
    public void OnEnterState()
    {
        _OnEnterState();
        EmitSignalEnterState();
    }

    // Method to override that adds context to the enter state method.
    protected abstract void _OnEnterState();

    // Method called when we exit the state.
    public void OnExitState()
    {
        _OnExitState();
        EmitSignalExitState();
    }

    // Method to override that adds context to the exit state method.
    protected abstract void _OnExitState();
    
    // Process callbacks.

    // Process on the current state.
    public abstract void _StateProcess(double delta);
    
    // PhysicsProcess on the current state.
    public abstract void _StatePhysicsProcess(double delta);
    
    // Transitioning.
    
    // Gets the context needed by transitions for computation.
    public abstract Dictionary<String, object> GetContext();

    // Computes the first transition that needs to be reached to.
    public State TransitionTo()
    {
        foreach(StateTransition outTransition in _outTransitions)
            if (outTransition.CanTransition(GetContext()))
                return GetNode(outTransition.TargetState) as State;

        return null;
    }
}
